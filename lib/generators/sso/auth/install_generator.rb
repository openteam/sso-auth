require 'rails/generators/migration'

module Sso
  module Auth
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include Rails::Generators::Migration

        source_root File.expand_path('../templates', __FILE__)

        def self.next_migration_number(dirname)
          @number ||= Time.now.strftime('%Y%m%d%H%M%S').to_i
          @number += 1
        end

        def create_models
          template 'app/models/ability.rb'
          template 'app/models/user.rb'
          template 'app/models/permission.rb'
        end

        def create_controllers
          template 'app/controllers/manage/application_controller.rb'
        end

        def create_seeds
          template 'db/seeds.rb'
        end

        def create_specs
          template 'spec/models/ability_spec.rb'
        end

        def create_migrations
          migration_template 'db/migrate/create_users.rb'
          migration_template 'db/migrate/create_permissions.rb'
        end

      end
    end
  end
end
