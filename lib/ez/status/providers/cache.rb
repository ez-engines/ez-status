# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class CacheException < StandardError; end

      class Cache
        def check
          time = Time.now.to_s
          Rails.cache.write(key, time)
          fetched = Rails.cache.read(key)
          fetched == time
        rescue Exception => e
          raise CacheException.new(e.message)
        end

        private

        def key
          @key ||= 'Ez::Status::Providers::Cache'
        end
      end
    end
  end
end
