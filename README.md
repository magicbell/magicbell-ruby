# magicbell

[MagicBell](https://magicbell.io) is an embeddable Notification Inbox for web applications.

This ruby gem

1. Is a wrapper around [MagicBell's REST API](https://developer.magicbell.io/reference). You can use it to create a notification in your MagicBell project etc.
2. Can BCC your ActionMailer email notifications to MagicBell if you rather not use MagicBell's API in your Rails application. MagicBell will create an in-app notification from any email notification that's blind copied to it.

<img width="415" alt="MagicBell Notification Inbox" src="https://user-images.githubusercontent.com/1789832/28327736-f3503f44-6c01-11e7-9a72-c15023db18c6.png">

## Installation

Sign up at magicbell.io and obtain your MagicBell project's API Key and API Secret from the "Settings" section in your MagicBell dashboard.

Add the gem to your app's Gemfile

```ruby
gem "magicbell"
```

and install the gem

```
bundle install
```

The gem will automatically pick your MagicBell project's API Key and API Secret from the `MAGICBELL_API_KEY` and `MAGICBELL_API_SECRET` environment variables. Alternatively, provide the API Key and API Secret in an initializer

```
vim config/initializers/magicbell.rb
```

```ruby
# config/initializers/magicbell.rb

MagicBell.configure do |config|
  config.api_key = "your_magicbell_api_key"
  config.api_secret = "your_magicbell_api_secret"
end
```

## API Wrapper

Send a notification to a user or many users

```ruby
magicbell = MagicBell::Client.new
magicbell.create_notification(
  "title" => "Rob assigned a task to you",
  "recipients" => [
    {
      email: "joe@example.com"
    },
  ]
)
```

You can even provide content for the notification and a URL to redirect the user to when they click on the notification the MagicBell Notification Inbox

```ruby
magicbell = MagicBell::Client.new
magicbell.create_notification(
  "title" => "Rob assigned to a task to you",
  "recipients" => [
    {
      email: "joe@example.com"
    },
  ],
  "content": "Hey Joe, can give this customer a demo of our app?",
  "action_url" => "https://yourwebsite.com/task_path"
)
```

Visit our API docs for more information on the Create Notification API endpoint.

Support for other API endpoints will be added shortly.

## Rails integration

If you've existing ActionMailer email notifications in your Rails app and prefer to not spend time migrating to MagicBell's API, you can blind copy your ActionMailer email notifications to MagicBell. MagicBell will create in-app notifications from email notifications blind copied to it.

Call the `ring_the_magicbell` method in your action mailers like in the example below

```ruby
class NotificationMailer < ActionMailer::Base
  # The ring_the_magicbell method will bcc your email notifications to your MagicBell project's BCC email address
  #
  # Upon receiving a blind copied email notification, magicbell.io will automatically create an in-app notification for the user
  ring_the_magicbell

  # This is an email notification in your app
  def new_comment
    # ...
  end
  
  # This is another email notification in your app
  def mentioned
    # ...
  end
end
```

The gem will automatically pick your MagicBell project's BCC email from the `MAGICBELL_BCC_EMAIL` environment variable. Alternatively, provide your MagicBell project's BCC email address in an initializer

```
vim config/initializers/magicbell.rb
```

```ruby
# config/initializers/magicbell.rb

MagicBell.configure do |config|
  config.api_key = "your_magicbell_api_key"
  config.api_secret = "your_magicbell_api_secret"
  config.bcc_email = "your_magicbell_bcc_email@ring.magicbell.io"
end
```

The BCC email address is available in the "Settings" section in your MagicBell dashboard.

## Advanced Usage

### Customize Action URL

When a user clicks on a notification in MagicBell's Notification Inbox, the Notification Inbox redirects the user to the first URL the body of the email notification. This URL is called the `action_url`.

If you wish to redirect users to a different URL instead, provide an `action_url` in your mailers

```ruby
class NotificationMailer < ActionMailer::Base
  ring_the_magicbell

  def new_comment(comment)
    # ...
    magicbell_notification_action_url("https://myapp.com/comments/#{comment.id}")
    # ...
  end
end
```

### Customize Notification Title

The Notification inbox will use the subject of the email notification as a notification's title. If this behaviour isn't sutiable for your app, provide a title in your mailers

```ruby
class NotificationMailer < ActionMailer::Base
  ring_the_magicbell

  def new_comment(comment)
    # ...
    magicbell_notification_title("Richard posted a new comment")
    # ...
  end
end
```

## Developer Hub

Please visit our [Developer Hub](https://developer.magicbell.io) for documentation on MagicBell's API and MagicBell's embeddable Notification Inbox
