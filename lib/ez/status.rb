# frozen_string_literal: true

require 'ez/status/version'
require 'ez/status/engine'

require 'ez/configurator'

module Ez
  module Status
    include Ez::Configurator

    configure do |config|
      config.status_base_controller = nil
      config.status_base_routes     = nil
      config.layout                 = nil
      config.basic_auth_credentials = {}

      config.status_table_name      = nil

      config.monitors = []

      config.ui_header         = nil
      config.ui_custom_css_map = {}
    end
  end
end
