# MagicBell Ruby Library

This library provides convenient access to the [MagicBell REST API](https://magicbell.com/docs/rest-api/overview) from applications written in Ruby. It includes helpers for creating notifications, fetching them, and calculating the HMAC for a user.

[MagicBell](https://magicbell.com) is the notification inbox for your web and mobile applications. You may find it helpful to familiarize yourself with the [core concepts of MagicBell](https://magicbell.com/docs/core-concepts).

<img width="415" alt="MagicBell Notification Inbox" src="https://files.readme.io/c09b21a-image1.png">

## Installation

First, [sign up for a MagicBell account](https://magicbell.com) and grab your MagicBell project's API key and secret from the "Settings" section of your MagicBell dashboard.

If you just want to use the package, run:

```
gem install magicbell
```

### Bundler

If you are installing via bundler, add the gem to your app's Gemfile:

```ruby
# Gemfile
source 'https://rubygems.org'

gem 'magicbell'
```

and run `bundle install` a usual.

## Configuration

The library needs to be configured with your MagicBell project's API key and secret.

### Global configuration

By default, this library will automatically pick your MagicBell project's API key and secret from the `MAGICBELL_API_KEY` and `MAGICBELL_API_SECRET` environment variables, respectively.

Alternatively, you can configure your MagicBell manually. For example, for a rails project, create an initializer file for MagicBell and set your project's keys:

```ruby
# config/initializers/magicbell.rb

MagicBell.configure do |config|
  config.api_key = 'MAGICBELL_API_KEY'
  config.api_secret = 'MAGICBELL_API_SECRET'
end
```

### Per-request configuration

For apps that need to use multiple keys during the lifetime of a process, provide the specific keys when you create instances of `MagicBell::Client`:

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new(
  api_key: 'MAGICBELL_PROJECT_API_KEY',
  api_secret: 'MAGICBELL_PROJECT_API_SECRET'
)
```

Please keep in mind that any instance of `MagicBell::Client` will default to the global configuration unless an API key and secret are provided.

## Usage

### Create a notification

You can send a notification to one or many users by identifying them by their email address:

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new
magicbell.create_notification(
  title: 'Rob assigned a task to you',
  recipients: [{
    email: 'joe@example.com'
  }, {
    email: 'mary@example.com'
  }]
)
```

Or you can identify users by an `external_id` (their ID in your database, for example):

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new
magicbell.create_notification(
  title: 'Rob assigned a task to you',
  recipients: [{
    external_id: 'DATABASE_ID'
  }]
)
```

This method has the benefit of allowing users to access their notifications when their email address changes. Make sure you identify users by their `externalID` when you [initialize the notification inbox](https://magicbell.com/docs/react/identifying-users), too.

You can also provide other data accepted by [our API](https://magicbell.com/docs/rest-api/reference):

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new
magicbell.create_notification(
  title: 'Rob assigned to a task to you',
  content: 'Hey Joe, can give this customer a demo of our app?',
  action_url: 'https://example.com/task_path',
  custom_attributes: {
    recipient: {
      first_name: 'Joe',
      last_name: 'Smith'
    }
  },
  overrides: {
    channels: {
      web_push: {
        title: 'New task assigned'
      }
    }
  },
  recipients: [{
    email: 'joe@example.com'
  }],
)
```

### Fetch a user's notifications

To fetch a user's notifications you can do this:

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new

user = magicbell.user_with_email('joe@example.com')
user.notifications.each { |notification| puts notification.attribute('title') }
```

Please note that the example above fetches the user's 15 most recent notifications (the default number per page). If you'd like to fetch subsequent pages, use the `each_page` method instead:

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new

user = magicbell.user_with_email('joe@example.com')
user.notifications.each_page do |page|
  page.each do |notification|
    puts notification.attribute('title')
  end
end
```

### Mark a user's notification as read/unread

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new

user = magicbell.user_with_email('joe@example.com')

notification = user.notifications.first
notification.mark_as_read
notification.mark_as_unread
```

### Mark all notifications of a user as read

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new

user = magicbell.user_with_email('joe@example.com')
user.mark_all_notifications_as_read
```

### Mark all notifications of a user as seen

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new

user = magicbell.user_with_email('joe@example.com')
user.mark_all_notifications_as_seen
```

### Error handling

This gem raises a `MagicBell::Client::HTTPError` if the MagicBell API returns a non-2xx response.

```ruby
require 'magicbell'

begin
  magicbell = MagicBell::Client.new
  magicbell.create_notification(
    title: 'Rob assigned to a task to you'
  )
rescue MagicBell::Client::HTTPError => e
  # Report the error to your error tracker, for example
  error_context = {
    response_status: e.response_status,
    response_headers: e.response_headers,
    response_body: e.response_body
  }

  ErrorReporter.report(e, context: error_context)
end
```

### Calculate the HMAC secret for a user

You can use the `MagicBell.hmac` method. Note that in this case, the API secret, which is used to generate the HMAC, will be fetched from the global configuration.

```ruby
require 'magicbell'

hmac = MagicBell.hmac('joe@example.com')
```

You can also use the API secret of a specific client instance to calculate the HMAC:

```ruby
require 'magicbell'

magicbell = MagicBell::Client.new(
  api_key: 'MAGICBELL_API_KEY',
  api_secret: 'MAGICBELL_API_SECRET'
)

hmac = magicbell.hmac('joe@example.com')
```

Please refer to our docs to know [how to turn on HMAC authentication](https://magicbell.com/docs/turn-on-hmac-authentication) for your MagicBell project.

## API docs

Please visit [our website](https://magicbell.com) and [our docs](https://magicbell.com/docs) for more information.

## Contact Us

Have a query or hit upon a problem? Feel free to contact us at [hello@magicbell.io](mailto:hello@magicbell.io).
