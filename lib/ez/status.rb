# frozen_string_literal: true

require 'ez/status/version'
require 'ez/status/engine'

require 'ez/configurator'

module Ez
  module Status
    include Ez::Configurator

    configure do |config|
      config.monitors = []

      config.basic_auth_credentials = {}

      config.layout = nil

      config.ui_header = nil
      config.ui_custom_css_map = {}
    end
  end
end
