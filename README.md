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
```

### ActiveRecord migrations:

**If you want save data to DataBase, please change configuration first**

config/initializers/ez_status.rb
```ruby
config.status_table_name = 'my_model_name'
```

And run
```bash
rails generate ez:status:migrations
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
  'ez-status-index-container'           => 'ui grid',
  'ez-status-index-inner-container'     => 'six wide column',
  'ez-status-index-monitors-collection' => 'ui middle aligned divided list',
  'ez-status-index-status'              => 'item',
  'ez-status-index-check-name'          => 'content',
  'ez-status-index-check-message'       => 'right floated content',
  'ez-status-index-check-value'         => 'right floated content',
  'ez-status-index-check-result'        => 'right floated content',
  'ez-status-index-check-name-span'     => 'ui green label'
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
