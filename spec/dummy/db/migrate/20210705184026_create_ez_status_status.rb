# frozen_string_literal: true
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
