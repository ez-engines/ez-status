# frozen_string_literal: true

require 'ez/status/version'
require 'ez/status/engine'
require 'ez/status/services'

require 'ez/configurator'

module Ez
  module Status
    DEFAULT_COLUMNS = %i[monitor_name message value result].freeze

    include Ez::Configurator

    extend Ez::Status::Services::Store
    extend Ez::Status::Services::Monitors

    configure do |config|
      config.status_base_controller = nil
      config.status_base_routes     = nil

      config.layout                 = nil

      config.basic_auth_credentials = {}

      config.columns = DEFAULT_COLUMNS

      config.active_record_table_name = :ez_status_records

      config.monitors = []

      config.ui_header         = nil
      config.ui_custom_css_map = {}
    end
  end
end
