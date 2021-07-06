# frozen_string_literal: true

# rubocop:disable all
module Ez
  module Status
    class MigrationsGenerator < Rails::Generators::Base
      def config
        Ez::Status.config
      end

      def table_name
        raise 'You need setup table name' if config.status_table_name.blank?
        config.status_table_name
      end

      def create_migration
        # TODO: ActiveRecord::Migration[6.0], add automatic detection [5.0], [5.1], [5.2], [6.1], [6.1], [6.2],
        create_file "db/migrate/#{Time.current.strftime('%Y%m%d%H%M%S')}_create_ez_status_#{table_name.underscore}.rb",
                    "# frozen_string_literal: true

class CreateEzStatus#{table_name.classify} < ActiveRecord::Migration[6.0]
  def change
    create_table :#{table_name.underscore} do |t|
      t.string :name,    null: false
      t.string :result,  null: true
      t.string :message, null: true
      t.string :value,   null: true

      t.timestamps null: false
    end
  end
end
"
      end
    end
  end
end
