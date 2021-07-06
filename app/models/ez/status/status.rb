# frozen_string_literal: true

module Ez
  module Status
    class Status < ApplicationRecord
      self.table_name = Ez::Status.config.status_table_name

      validates :name,    presence: true
      validates :result,  presence: false
      validates :message, presence: false
      validates :value,   presence: false
    end
  end
end
