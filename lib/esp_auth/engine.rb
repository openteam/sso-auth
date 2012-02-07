module EspAuth
  class Engine < Rails::Engine
    isolate_namespace EspAuth

    config.after_initialize do
      begin
        Settings.resolve!
      rescue => e
        puts "WARNING! #{e.message}"
      end
    end

    initializer "sso_client.devise", :before => 'devise.omniauth' do |app|
      require File.expand_path("../../../lib/omniauth/strategies/identity", __FILE__)

      Settings.define 'sso.url',    :env_var => 'SSO_URL',    :required => true
      Settings.define 'sso.key',    :env_var => 'SSO_KEY',    :required => true
      Settings.define 'sso.secret', :env_var => 'SSO_SECRET', :required => true

      Devise.setup do |config|
        config.omniauth :identity, Settings['sso.key'], Settings['sso.secret'], :client_options => {:site => Settings['sso.url']}
      end
    end

    config.to_prepare do
      ActionController::Base.class_eval do
        def self.esp_load_and_authorize_resource
          before_filter :authenticate_user!
          before_filter :authorize_user_can_manage_application!
          inherit_resources
          load_and_authorize_resource
          rescue_from CanCan::AccessDenied do |exception|
            render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
          end
        end
        protected
        def authorize_user_can_manage_application!
            authorize! :manage, :application
        end
      end
      ActiveRecord::Base.class_eval do
        def self.esp_authable

          attr_accessible :name, :email, :nickname, :name, :first_name, :last_name, :location, :description, :image, :phone, :urls, :raw_info, :uid

          has_many :permissions

          default_value_for :sign_in_count, 0

          devise :omniauthable, :trackable, :timeoutable

          searchable do
            integer :uid
            text :term do [name, email, nickname].join(' ') end
            integer :permissions_count do permissions.count end
          end

          Permission.enums[:role].each do | role |
            define_method "#{role}_of?" do |context|
              permissions.for_role(role).for_context_and_ancestors(context).exists?
            end
            define_method "#{role}?" do
              permissions.for_role(role).exists?
            end
          end

          define_method :have_permissions? do
            permissions.exists?
          end

          alias_method :have_roles?, :have_permissions?

          define_method :contexts do
            permissions.map(&:context).uniq
          end

          define_method :contexts_tree do
            contexts.flat_map{|c| c.respond_to?(:subtree) ? c.subtree : c}
            .uniq
            .flat_map{|c| c.respond_to?(:subcontexts) ? [c] + c.subcontexts : c }
            .uniq
          end

        end
      end
    end
  end
end
