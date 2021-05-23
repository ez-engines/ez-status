# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class Sidekiq
        def check
          !!::Sidekiq.redis(&:info)
        rescue
          false
        end
      end
    end
  end
end
