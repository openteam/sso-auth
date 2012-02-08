require 'rails/generators/migration'

module EspAuth
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
        template 'app/models/context.rb'
        template 'app/models/permission.rb'
        template 'app/models/subcontext.rb'
      end

      def create_controllers
        template 'app/controllers/manage/application_controller.rb'
      end

      def create_config
        template 'config/schedule.rb'
        template 'config/locales/permissions_enum.ru.yml'
      end

      def create_seeds
        template 'db/seeds.rb'
      end

      def create_specs
        template 'spec/models/ability_spec.rb'
      end

      def create_migrations
        migration_template 'db/migrate/create_users.rb'
        migration_template 'db/migrate/create_contexts.rb'
        migration_template 'db/migrate/create_permissions.rb'
        migration_template 'db/migrate/create_subcontexts.rb'
      end

    end
  end
end
