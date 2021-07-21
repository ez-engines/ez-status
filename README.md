# Ez::Status
TODO.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ez-status'
```

And then execute:
```bash
$ bundle install
```

## Generators
Run rails generator for easy config setup:
```bash
$ rails generate ez:status:install
```

## Usage

You can mount this inside your app routes by adding this to `config/routes.rb`:

```ruby
mount Ez::Status::Engine, at: '/status'
```

## Configuration

Configuration interface allows you to change default behavior

```ruby
# config/initializers/ez_status.rb

require 'ez/status/providers/database'
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

  # You can change layout, default is using application layout
  # config.layout = 'layouts/application'

  # You can change the header text
  # config.ui_header = 'MyStatus'

  # Basic Authentication
  # config.basic_auth_credentials = {
  #   username: 'MyUsername',
  #   password: 'MyPassword'
  # }

  # Order columns and which columns need to show
  # config.columns = [ :message, :value, :result, :monitor_name,]

  # DB table name, that you can change as well
  # config.active_record_table_name = :ez_status_records

  # Define your monitors
  config.monitors = [
    Ez::Status::Providers::Database,
    Ez::Status::Providers::Cache,
  # Ez::Status::Providers::DelayedJob,
  # Ez::Status::Providers::Redis,
  # Ez::Status::Providers::Sidekiq,
  # MyCustomProvider
  ]

  # Pass your custom css classes through css_map config
  # Defaults would be merged with yours:
  # config.ui_custom_css_map = {
  #   'ez-status-index-container'           => 'your_css_class',
  #   'ez-status-index-inner-container'     => 'your_css_class',
  # 
  #   # header
  #   'ez-status-index-inner-header'        => 'your_css_class',
  #   'ez-status-index-inner-title'         => 'your_css_class',
  #   'ez-status-index-inner-title-span'    => 'your_css_class',
  # 
  #   # monitors
  #   'ez-status-index-monitors-collection' => 'your_css_class',
  # 
  #   # monitor
  #   'ez-status-index-status'                  => 'your_css_class',
  #   'ez-status-index-failed'                  => 'your_css_class',
  # 
  #   'ez-status-index-check-monitor-name'      => 'your_css_class',
  #   'ez-status-index-check-monitor-name-span' => 'your_css_class'
  #
  #   'ez-status-index-check-message'           => 'your_css_class',
  #   'ez-status-index-check-message-span'      => 'your_css_class',
  #
  #   'ez-status-index-check-value'             => 'your_css_class',
  #   'ez-status-index-check-value-span'        => 'your_css_class',
  #
  #   'ez-status-index-check-result'            => 'your_css_class',
  #   'ez-status-index-check-result-span'       => 'your_css_class',
  #
  # }
end
```

### ActiveRecord migrations:

**If you want save results  to DB (PostgreSQL, etc), please change configuration first**

Uncomment DB table name:
```ruby
# config/initializers/ez_status.rb

# DB table name, that you can change as well
config.active_record_table_name = :ez_status_records
```

And run the generator:

```bash
rails generate ez:status:migrations
```

Then run migrations

```bash
rails db:migrate
```

After that you have a method to save all results  to DB

```bash
Ez::Status.capture!
```

#### Example for [Whenever gem](https://github.com/javan/whenever)
```bash
# config/schedule.rb

every 5.minute do
  runner "Ez::Status.capture!"
end

```

#### Example for [Sidekiq-Cron gem](https://github.com/ondrejbartas/sidekiq-cron)
```bash
# config/schedule.rb

ez_status_check_all_services:
  name:  "Ez::Status check all services in config.monitors and save results  to DB"
  cron:  "*/5 * * * *"
  class: "Ez::Status.capture!"
  queue: scheduler

```

### Basic Authentication

```ruby
Ez::Status.configure do |config|
  config.basic_auth_credentials = {
    username: 'MyUsername',
    password: 'MyPassword'
  }
end
```

### Change Header

```ruby
Ez::Status.configure do |config|
  config.ui_header = 'My Header'
end
```

### Change columns view

```ruby
# Order columns and which columns need to show
config.columns = [:message, :value, :result, :monitor_name,]
```

## Examples

```ruby
class MyCustomProvider
  def check
    uri = URI.parse('http://www.google.com/')
    request = Net::HTTP::Get.new(uri)
    req_options = {
      use_ssl: uri.scheme == 'https',
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    [response.code == '200', response.message, response.code]
  rescue StandardError => e
    [false, e.message]
  end
end

Ez::Status.configure do |config|
  config.monitors = [
    MyCustomProvider
  ]
end

### HTML version

TODO: HTML page screenshot here


## JSON version

```json
{
  "todo": "todo"
}
```

## Creating a Custom Provider

Custom provider, it's just a simple ruby PORO. You don't need to use any custom inheritance or include modules.
Just create your own class with 1 public method `run!` and raise an exception in case of failure or return anything else as success message.

```ruby
class MyCustomProvider
  def check
    raise 'Oops!' if false

    'OK'
  end
end
```

## Creating a Custom Style

### Style for Semantic Ui

```ruby
config.ui_custom_css_map = {
  'ez-status-index-container'               => 'ui grid',
  'ez-status-index-inner-container'         => 'six wide column',
  'ez-status-index-monitors-collection'     => 'ui middle aligned divided list',
  'ez-status-index-status'                  => 'item',
  'ez-status-index-check-monitor-name'      => 'content',
  'ez-status-index-check-monitor-name-span' => 'ui green label',
  'ez-status-index-check-message'           => 'right floated content',
  'ez-status-index-check-value'             => 'right floated content',
  'ez-status-index-check-result'            => 'right floated content'
}
```

## TODO

-
- 
- 

## Author

Volodya Sveredyuk, Telegram Channel: [SveredyukCast](https://t.me/svcast)

Vasyl Shevchenko, GitHub: [VasylShevchenko](https://github.com/VasylShevchenko)

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
