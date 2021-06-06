# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class SidekiqException < StandardError; end

      class Sidekiq
        def check
          ::Sidekiq.redis(&:info).present?
        rescue Exception => e
          raise SidekiqException.new(e.backtrace)
        end
      end
    end
  end
end
