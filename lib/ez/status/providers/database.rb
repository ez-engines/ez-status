# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class DatabaseException < StandardError; end

      class Database
        def check
          ActiveRecord::Base.establish_connection # Establishes connection
          ActiveRecord::Base.connection # Calls connection object
          ActiveRecord::Base.connected?
        rescue StandardError => e
          raise DatabaseException, e.message
        end
      end
    end
  end
end
