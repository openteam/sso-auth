module SsoAuth
  class Engine < Rails::Engine
    isolate_namespace SsoAuth

    config.after_initialize do
      begin
        Settings.resolve!
      rescue => e
        puts "WARNING! #{e.message}"
      end
    end

    initializer "sso_client.devise", :before => 'devise.omniauth' do |app|
      require File.expand_path("../../../lib/omniauth/strategies/identity", __FILE__)
      Devise.setup do |config|
        config.omniauth :identity, Settings['sso.key'], Settings['sso.secret'], :client_options => {:site => Settings['sso.url']}
      end
    end

    config.to_prepare do
      ActionController::Base.class_eval do
        def self.sso_load_and_authorize_resource
          before_filter :authenticate_user!
          before_filter :authorize_user_can_manage_application!
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
        def self.sso_auth_user
          has_many :permissions

          default_value_for :sign_in_count, 0

          devise :omniauthable, :trackable, :timeoutable

          delegate :exists?, :to => :permissions, :prefix => true

          Permission.available_roles.each do |role|
            define_method "#{role}_of?" do |context|
              permissions.for_role(role).for_context(context).exists?
            end
            define_method "#{role}?" do
              permissions.for_role(role).exists?
            end
          end

          define_method :sso_name do
            email? ? "#{name} <#{email}>" : name
          end
        end

        def self.sso_auth_permission(options)
          define_singleton_method :available_roles do
            options[:roles]
          end

          belongs_to :context, :polymorphic => true
          belongs_to :user

          validates_inclusion_of :role, :in => available_roles
          validates_presence_of :role, :user
          validates_uniqueness_of :role, :scope => [:user_id, :context_id, :context_type]

          scope :for_role,    ->(role)    { where(:role => role) }
          scope :for_context, ->(context) { context ? where(:context_id => context.id, :context_type => context.class) : where(:context_id => nil) }
        end
      end
    end
  end
end
