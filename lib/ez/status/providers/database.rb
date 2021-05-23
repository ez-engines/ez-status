# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class Database
        def check
          begin
            ActiveRecord::Base.establish_connection # Establishes connection
            ActiveRecord::Base.connection # Calls connection object
            ActiveRecord::Base.connected? ? true : false
          rescue
            false
          end
        end
      end
    end
  end
end
