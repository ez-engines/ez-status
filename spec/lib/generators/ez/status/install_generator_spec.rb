# frozen_string_literal: true

require 'generator_spec'
require 'generators/ez/status/install_generator'

fdescribe Ez::Status::InstallGenerator, type: :generator do
  destination File.expand_path('../../../../../tmp', __dir__)
  arguments %w[something]

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a config initializer' do
    assert_file 'config/initializers/ez_status.rb', "require 'ez/status/providers/database'
require 'ez/status/providers/cache'
# require 'ez/status/providers/delayed_job'
# require 'ez/status/providers/redis'
# require 'ez/status/providers/resque'
# require 'ez/status/providers/sidekiq'

# class MyCustomProvider
#   def check
#     uri = URI.parse('http://www.google.com/')
#     request = Net::HTTP::Get.new(uri)
#     req_options = {
#       use_ssl: uri.scheme == 'https',
#     }
#
#     response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
#       http.request(request)
#     end
#     [response.code == '200', response.message, response.code]
#   rescue StandardError => e
#     [false, e.message]
#   end
# end

Ez::Status.configure do |config|
  # config.ui_header = 'MyStatus'

  # config.basic_auth_credentials = {
  #   username: 'MyUsername',
  #   password: 'MyPassword'
  # }

  config.monitors = [
    Ez::Status::Providers::Database,
    Ez::Status::Providers::Cache,
    # Ez::Status::Providers::DelayedJob,
    # Ez::Status::Providers::Redis,
    # Ez::Status::Providers::Resque,
    # Ez::Status::Providers::Sidekiq,
    # MyCustomProvider
  ]
end
"
  end
end
