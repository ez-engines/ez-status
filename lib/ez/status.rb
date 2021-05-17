require 'ez/status/version'
require 'ez/status/engine'

require 'ez/configurator'

module Ez
  module Status
    include Ez::Configurator

    configure do |config|
      config.monitors = []
      config.ui_custom_css_map = {}
    end
  end
end
