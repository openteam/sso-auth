module EspAuth
  class Engine < Rails::Engine
    isolate_namespace EspAuth

    config.after_initialize do
      begin
        Settings.resolve!
      rescue => e
        puts 'WARNING! #{e.message}'
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
  end
end
