# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class ResqueException < StandardError; end

      class Resque
        def check
          ::Resque.info ? true : false
        rescue Exception => e
          raise ResqueException.new(e.message)
        end
      end
    end
  end
end
