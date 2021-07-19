class CreateEzStatusRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :ez_status_records do |t|
      t.string  :monitor_name, null: false
      t.boolean :result,       null: true
      t.string  :message,      null: true
      t.bigint  :value,        null: true

      t.datetime :created_at,  null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
