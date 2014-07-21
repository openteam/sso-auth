module Sso
  module Auth
    class Engine < ::Rails::Engine
      isolate_namespace Sso::Auth

      config.after_initialize do
        begin
          Settings.define 'sso.url',       :env_var => 'SSO_URL',       :require => true
          Settings.define 'sso.key',       :env_var => 'SSO_KEY',       :require => true
          Settings.define 'sso.secret',    :env_var => 'SSO_SECRET',    :require => true
          Settings.define 'devise.secret', :env_var => 'DEVISE_SECRET', :require => true

          Settings.resolve!
        rescue => e
          puts "WARNING! #{e.message}"
        end
      end

      initializer "sso_client.devise", :before => 'devise.omniauth' do |app|
        require File.expand_path("../../../omniauth/strategies/identity", __FILE__)
        Devise.setup do |config|
          config.omniauth :identity, Settings['sso.key'], Settings['sso.secret'], :client_options => { :site => Settings['sso.url'] }
        end
      end

      config.to_prepare do
        ActionController::Base.class_eval do
          define_singleton_method :sso_authenticate_and_authorize do
            before_filter :authenticate_user!
            before_filter :authorize_manage_application!
            rescue_from CanCan::AccessDenied do |exception|
              render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
            end
          end

          define_singleton_method :sso_load_and_authorize_resource do
            sso_authenticate_and_authorize
            inherit_resources
            load_and_authorize_resource
          end

          protected

          define_method :authorize_manage_application! do
            authorize! :manage, :application
          end
        end
        ActiveRecord::Base.class_eval do
          def self.sso_auth_user
            has_many :permissions, :dependent => :destroy

            devise :omniauthable, :trackable, :timeoutable

            Permission.available_roles.each do |role|
              define_method "#{role}_of?" do |context|
                permissions.for_role(role).for_context(context).exists?
              end
              define_method "#{role}?" do
                permissions.for_role(role).exists?
              end
            end

            define_method :sso_auth_name do
              email? ? "#{name} <#{email}>" : name
            end

            define_method :after_oauth_authentication do
              #NOTE: there is your implementation
            end

            define_singleton_method :find_or_create_by_omniauth_hash do |omniauth_hash|
              user = User.find_by_uid(omniauth_hash[:uid])
              user ||= User.find_by_email(omniauth_hash[:info][:email]) if omniauth_hash[:info][:email].present?
              user ||= User.new
              user.uid = omniauth_hash[:uid]
              attributes = omniauth_hash[:extra][:raw_info][:user].dup || {}
              attributes.delete(:uid)
              attributes = attributes.merge(omniauth_hash[:info])
              attributes[:raw_info] = omniauth_hash[:extra][:raw_info].to_json
              attributes.each do |attribute, value|
                user.send("#{attribute}=", value) if user.respond_to?("#{attribute}=")
              end
              user.save(:validate => false)
              user.after_oauth_authentication
              user
            end
            rewrite_devise_session_methods
          end

          def self.sso_auth_permission(options)
            define_singleton_method :available_roles do
              options[:roles].map(&:to_s)
            end

            belongs_to :context, :polymorphic => true
            belongs_to :user

            validates_inclusion_of :role, :in => available_roles + available_roles.map(&:to_sym)
            validates_presence_of  :role

            scope :for_role,    ->(role)    { where(:role => role) }
            scope :for_context, ->(context) { where(:context_id => context.try(:id), :context_type => context.try(:class)) }
          end

          define_singleton_method :rewrite_devise_session_methods do
            def self.serialize_into_session(record)
              [record.uid.to_s, record.authenticatable_salt]
            end

            def self.serialize_from_session(key, salt)
              record = find_by(:uid => key.to_s)
              record if record && record.authenticatable_salt == salt
            end
          end
        end
      end
    end
  end
end
