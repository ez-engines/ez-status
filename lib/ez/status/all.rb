# frozen_string_literal: true

[
  database,
  cache,
  delayed_job,
  redis,
  resque,
  sidekiq
].each do |provider|
  require "ez/status/providers/#{provider}"
end
