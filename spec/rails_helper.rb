# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'fakeredis'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../spec/dummy/config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'pry-rails'
require 'capybara/rails'
require 'byebug'

require 'redis'
require 'resque'
require 'sidekiq'
require 'delayed_job_active_record'

Dir[Ez::Status::Engine.root.join('spec/support/*.rb')].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Dir['../spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
