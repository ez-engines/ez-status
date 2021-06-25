# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class CacheException < StandardError; end

      class Cache
        def check
          Rails.cache.write(key, time_now)
          fetched = Rails.cache.read(key)
          fetched == time_now
        rescue StandardError => e
          raise CacheException, e.message
        end

        private

        def key
          @key ||= 'Ez::Status::Providers::Cache'
        end

        def time_now
          @time_now ||= Time.now.to_s
        end
      end
    end
  end
end
