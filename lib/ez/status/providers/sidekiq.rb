# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class SidekiqException < StandardError; end

      class Sidekiq
        def check
          ::Sidekiq.redis(&:info).present?
        rescue StandardError => e
          raise SidekiqException, e.message
        end
      end
    end
  end
end
