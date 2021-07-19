# frozen_string_literal: true

require 'generator_spec'
require 'generators/ez/status/migrations_generator'

describe Ez::Status::MigrationsGenerator, type: :generator do
  destination File.expand_path('../../../../../tmp', __dir__)
  arguments %w[something]

  let(:delay_in_seconds) { 5 }
  let(:current_time)     { Time.now.strftime('%Y%m%d%H%M%S') }
  let(:table_name)       { :ez_status_records } # Default table name lib/ez/status.rb
  let(:current_version)  { ActiveRecord::Migration.current_version }

  before do
    prepare_destination
    run_generator
  end

  # rubocop:disable RSpec/ExampleLength
  it 'creates a migration' do
    assert_file "db/migrate/#{current_time}_create_#{table_name.to_s.underscore}.rb",
                "class Create#{table_name.to_s.camelize} < ActiveRecord::Migration[#{current_version}]
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
  # rubocop:enable RSpec/ExampleLength
end
