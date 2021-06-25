# frozen_string_literal: true

module Ez
  module Status
    module Providers
      class RedisException < StandardError; end

      class Redis
        def check
          time = Time.now.to_s(:rfc2822)

          redis.set(key, time)
          fetched = redis.get(key)

          fetched == time
        rescue StandardError => e
          raise RedisException, e.message
        ensure
          redis.close
        end

        private

        def key
          @key ||= 'EzStatusProvidersRedis'
        end

        def redis
          @redis = ::Redis.new
        end
      end
    end
  end
end
