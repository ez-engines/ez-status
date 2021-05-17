require 'cells-rails'
require 'cells-slim'

module Ez
  module Status
    class Engine < ::Rails::Engine
      isolate_namespace Ez::Status
    end
  end
end
