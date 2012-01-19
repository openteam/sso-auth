require 'rails/generators/migration'

module EspPermissions
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(dirname)
        Time.now.strftime('%Y%m%d%H%M%S')
      end

     def create_models
       template 'app/models/user.rb'
       template 'app/models/permission.rb'
     end

      def create_migration
        migration_template 'db/migrate/esp_permissions_create_users.rb'
        migration_template 'db/migrate/esp_permissions_create_permissions.rb'
      end
    end
  end
end
