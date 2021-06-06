# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class DelayedJobException < StandardError; end

      class DelayedJob
        DEFAULT_QUEUES_SIZE = 100

        def check
          ::Delayed::Job.count < DEFAULT_QUEUES_SIZE
        rescue Exception => e
          raise DelayedJobException.new(e.message)
        end
      end
    end
  end
end
