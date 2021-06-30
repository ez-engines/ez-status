# frozen_string_literal: true

require_relative 'lib/ez/status/version'

Gem::Specification.new do |spec|
  spec.name        = 'ez-status'
  spec.version     = Ez::Status::VERSION
  spec.authors     = ['Vasyl Shevchenko']
  spec.email       = ['vasya.shevchenko.2011@gmail.com']
  spec.homepage    = 'https://github.com/ez-engines/ez-status'
  spec.summary     = 'Ez::Status is a Rails plug-in for checking services like db, cache, sidekiq, redis, etc.'
  spec.description = 'Ez::Status is a Rails plug-in for checking services like db, cache, sidekiq, redis, etc.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  spec.required_ruby_version       = '>= 2.4.0', '< 3'
  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ez-engines/ez-status'
  spec.metadata['changelog_uri']   = 'https://github.com/ez-engines/ez-status/blob/master/CHANGELOG.md'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'ez-core', '~> 0.2.0'
  spec.add_dependency 'rails',   '>= 5.0.0', '< 7.0.0'

  spec.add_dependency 'cells-rails', '~> 0.1.0'
  spec.add_dependency 'cells-slim',  '~> 0.0.6'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'delayed_job_active_record'
  spec.add_development_dependency 'fakeredis'
  spec.add_development_dependency 'generator_spec'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'launchy'
  spec.add_development_dependency 'pry-rails'
  spec.add_development_dependency 'rails-controller-testing'
  spec.add_development_dependency 'redis'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'sidekiq'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sqlite3'
end
