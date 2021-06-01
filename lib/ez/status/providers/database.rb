# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class Database
        def check
          ActiveRecord::Base.establish_connection # Establishes connection
          ActiveRecord::Base.connection # Calls connection object
          ActiveRecord::Base.connected?
        rescue
          false
        end
      end
    end
  end
end
