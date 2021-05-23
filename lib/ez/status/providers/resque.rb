# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class Resque
        def check
          ::Resque.info ? true : false
        rescue
          false
        end
      end
    end
  end
end
