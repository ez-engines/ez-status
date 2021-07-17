# frozen_string_literal: true

module Ez
  module Status
    class Records < ApplicationRecord
      self.table_name = Ez::Status.config.active_record_table_name

      validates :monitor_name, presence: true
    end
  end
end
