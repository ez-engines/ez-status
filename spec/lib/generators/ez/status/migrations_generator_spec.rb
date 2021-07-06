# frozen_string_literal: true

require 'generator_spec'
require 'generators/ez/status/migrations_generator'

describe Ez::Status::MigrationsGenerator, type: :generator do
  destination File.expand_path('../../../../../tmp', __dir__)
  arguments %w[something]

  around do |spec|
    Ez::Status.config.status_table_name = 'status'
    spec.run
    Ez::Status.config.status_table_name = nil
  end

  before do
    prepare_destination
    run_generator
  end

  it 'creates a migration' do
    assert_file "# frozen_string_literal: true

class CreateEzStatusStatus < ActiveRecord::Migration[6.0]
  def change
    create_table :status do |t|
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
