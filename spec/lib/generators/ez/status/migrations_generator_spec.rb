# frozen_string_literal: true

require 'generator_spec'
require 'generators/ez/status/migrations_generator'

describe Ez::Status::MigrationsGenerator, type: :generator do
  destination File.expand_path('../../../../../tmp', __dir__)
  arguments %w[something]

  let(:delay_in_seconds) { 5 }
  let(:current_time)     { Time.now.strftime('%Y%m%d%H%M%S') }
  let(:table_name)       { :ez_status_store }
  let(:current_version)  { ActiveRecord::Migration.current_version }

  before do
    Ez::Status.config.active_record_table_name = :ez_status_store
    prepare_destination
    run_generator
  end

  # rubocop:disable RSpec/ExampleLength
  it 'creates a migration' do
    assert_file "db/migrate/#{current_time}_create_#{table_name.to_s.underscore}.rb",
                "class Create#{table_name.to_s.classify} < ActiveRecord::Migration[#{current_version}]
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
  # rubocop:enable RSpec/ExampleLength
end
