# frozen_string_literal: true

# rubocop:disable all
module Ez
  module Status
    class MigrationsGenerator < Rails::Generators::Base
      def create_migration
        create_file "db/migrate/#{current_time}_create_#{table_name.to_s.underscore}.rb",
                    "class Create#{table_name.to_s.classify} < ActiveRecord::Migration[#{ActiveRecord::Migration.current_version}]
  def change
    create_table :#{table_name.to_s.underscore} do |t|
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

      private

      def config
        Ez::Status.config
      end

      def table_name
        raise 'You need setup active_record_table_name in config file' if config.active_record_table_name.blank?
        config.active_record_table_name
      end

      def current_time
        Time.now.strftime('%Y%m%d%H%M%S')
      end

    end
  end
end
