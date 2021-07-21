# frozen_string_literal: true

# rubocop:disable all
module Ez
  module Status
    class MigrationsGenerator < Rails::Generators::Base
      def create_migration
        create_file "db/migrate/#{current_time}_create_#{table_name.to_s.underscore}.rb",
                    "class Create#{table_name.to_s.camelize} < ActiveRecord::Migration[#{ActiveRecord::Migration.current_version}]
  def change
    create_table :#{table_name.to_s.underscore} do |t|
      t.string  :monitor_name, null: false
      t.boolean :result,       null: true
      t.string  :message,      null: true
      t.bigint  :value,        null: true

      t.datetime :created_at,  null: false, default: -> { 'CURRENT_TIMESTAMP' }
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
        config.active_record_table_name
      end

      def current_time
        Time.now.strftime('%Y%m%d%H%M%S')
      end

    end
  end
end
