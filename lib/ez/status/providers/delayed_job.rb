# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class DelayedJob
        DEFAULT_QUEUES_SIZE = 100

        def check
          ::Delayed::Job.count < DEFAULT_QUEUES_SIZE ? true : false
        rescue
          false
        end
      end
    end
  end
end
