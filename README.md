# magicbell-ruby

[MagicBell](https://magicbell.io) is an embeddable Notification Inbox for web & mobile applications.

Please familiarlize yourself with the [core concepts of MagicBell](https://developer.magicbell.io/docs/core-concepts) before using this gem.

This gem

1. Makes it easy to interact with [MagicBell's REST API](https://developer.magicbell.io/reference) from Ruby.

   You can use it to create a notification in your MagicBell project etc.

2. Helps you calculate the HMAC for a user's email or external_id when you turn on [HMAC Authentication](https://developer.magicbell.io/docs/turn-on-hmac-authentication) for your MagicBell project

<img width="415" alt="MagicBell Notification Inbox" src="https://files.readme.io/c09b21a-image1.png">

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

This gem makes it easy to interact with MagicBell's REST API https://developer.magicbell.io/reference from Ruby

### Create a notification

Send a notification to one or many users by identifying them with their email address

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

You can also identify users with their `external_id`, which is their ID in your database. That way, if their email address changes, they'd still have access to their notifications. You'll need to make sure you identify them with their `externalID` [in your frontend](https://developer.magicbell.io/docs/browser-js#identifying-users).

```ruby
     magicbell.create_notification(
          title: "Welcome to Muziboo",
          recipients: [{
            external_id: "id_in_your_database"
          }]
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

### Fetch a user's notifications

Fetch a user's notifications

```ruby
magicbell = MagicBell::Client.new
user = magicbell.user_with_email("joe@example.com")
user_notifications = user.notifications
user_notifications.each { |user_notification| puts user_notification.attribute("title") }
```

Please note that the example above fetches the user's 15 most recent notification (the default number of notifications per page) If you'd like to fetch subsequent pages, use

```ruby
magicbell = MagicBell::Client.new
user = magicbell.user_with_email("joe@example.com")
user_notifications = user.notifications
user_notifications.each_page do |page|
  page.each do |user_notification|
    puts user_notification.attribute("title")
  end
end
```

### Mark a user notification as read/unread

```ruby
magicbell = MagicBell::Client.new
user = magicbell.user_with_email("joe@example.com")
user_notification = user.notifications.first
user_notification.mark_as_read
user_notification.mark_as_unread
```

### Mark all notifications of a user as read/seen

```ruby
magicbell = MagicBell::Client.new
user = magicbell.user_with_email("joe@example.com")
user.mark_all_notifications_as_read
user.mark_all_notifications_as_seen
```

### Error handling

Please note that the gem raises a `MagicBell::Client::HTTPError` if an API returns a non 2xx response

```ruby
begin
  magicbell = MagicBell::Client.new
  magicbell.create_notification(
    "title" => "Rob assigned to a task to you"
  )
rescue MagicBell::Client::HTTPError => e
  # Report the error to your error tracker
  error_context = {
    response_status: e.response_status,
    response_headers: e.response_headers,
    response_body: e.response_body
  }
  ErrorReporter.report(e, context: error_context)
end
```

## Rails integration
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

## HMAC Authentication

### Calculate HMAC

```
user_email = "joe@example.com"
hmac = MagicBell.hmac(user_email)
```

See https://developer.magicbell.io/docs/turn-on-hmac-authentication for more information on turning on HMAC Authentication for your MagicBell Project

## API docs

Please visit our website https://magicbell.io and our API docs https://developer.magicbell.io for more information MagicBell's embeddable notification inbox and MagicBell's REST API

## Contact Us

Have a query or hit upon a problem? Create a post in our Developer Community https://community.magicbell.io or contact us at hello@magicbell.io

```

```
