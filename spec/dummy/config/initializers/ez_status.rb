require 'ez/status/providers/database'

Ez::Status.configure do |config|
  config.monitors = [
    Ez::Status::Providers::Database
  ]
end
