# frozen_string_literal: true

module Ez
  module Status
    class InstallGenerator < Rails::Generators::Base
      def create_initializer_file
        create_file 'config/initializers/ez_status.rb',
                    "require 'ez/status/providers/database'
require 'ez/status/providers/cache'
# require 'ez/status/providers/delayed_job'
# require 'ez/status/providers/redis'
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
  # Define your base controller and routes
  config.status_base_controller = 'ApplicationController'
  config.status_base_routes = '/status'

  # config.layout = 'layouts/application'

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
    # Ez::Status::Providers::Sidekiq,
    # MyCustomProvider
  ]

  # config.ui_custom_css_map = {
  #   'ez-status-index-container'           => 'your_css_class',
  #   'ez-status-index-inner-container'     => 'your_css_class',
  #   # heder
  #   'ez-status-index-inner-header'        => 'your_css_class',
  #   'ez-status-index-inner-title'         => 'your_css_class',
  #   'ez-status-index-inner-title-span'    => 'your_css_class',
  #   # monitors
  #   'ez-status-index-monitors-collection' => 'your_css_class',
  #   # monitor
  #   'ez-status-index-status'              => 'your_css_class',
  #   'ez-status-index-failed'              => 'your_css_class',
  #
  #   'ez-status-index-check-message'       => 'your_css_class',
  #   'ez-status-index-check-message-span'  => 'your_css_class',
  #
  #   'ez-status-index-check-value'         => 'your_css_class',
  #   'ez-status-index-check-value-span'    => 'your_css_class',
  #
  #   'ez-status-index-check-result'        => 'your_css_class',
  #   'ez-status-index-check-result-span'   => 'your_css_class',
  #
  #   'ez-status-index-check-name'          => 'your_css_class',
  #   'ez-status-index-check-name-span'     => 'your_css_class'
  # }
end
"
      end
    end
  end
end
