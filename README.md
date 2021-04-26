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

## Configuration

Configuration interface allows you to change default behavior

```ruby
# config/initializers/ez_status.rb
Ez::Status.configure do |config|
  config.monitors = [
    Ez::Status::Providers::Database.new,
    Ez::Status::Providers::Cache.new,
    # Ez::Status::Providers::Redis.new,
    # Ez::Status::Providers::Sidekiq.new,
    # MyCustomProvider.new,
  ]

  # Status page ships with default generated CSS classes.
  # You can always inspect them in the browser and override
  config.ui_custom_css_map = {
    'ez-status-container' => 'you custom css classes here'
  }
end
```

## Examples

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
  def run!
    raise 'Oops!' if false

    'OK'
  end
end
```

## Usage

You can mount this inside your app routes by adding this to `config/routes.rb`:

```ruby
mount Ez::Status::Engine, at: '/status'
```

## Contributing
TODO

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
