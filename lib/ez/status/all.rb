%w(
  database
  cache
  delayed_job
  redis
  resque
  sidekiq
).each do |provider|
  begin
    require "ez/status/providers/#{provider}"
  rescue LoadError
  end
end
