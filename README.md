# magicbell-rails

This gem makes it easy to add [MagicBell's](https://magicbell.io/) notification center widget to your rails app.

## Installation

Add the magicbell gem to your app's Gemfile

```ruby
gem "magicbell-rails"
```

Run

```
bundle install
```

Create the initializer file `config/initializers/magicbell-rails.rb` and add your MagicBell credentials there.

```
vim config/initializers/magicbell-rails.rb
```

```ruby
MagicBellRails.configure do |config|
  config.api_key = "your_magicbell_api_key"
  config.api_secret = "your_magicbell_api_secret"
  config.project_id = 1 # your magicbell project id
  config.magic_address = "your_magicell_magic_address@ring.magicbell.io"
end
```

If you haven't yet signed up for MagicBell and don't have credentials, sign up [here](https://magicbell.io/)

Create the partial file `config/layouts/_magicbell.html.erb` and copy paste the code below

```erb
<!-- MagicBell widget -->
<script>
  $('<link/>', {
    rel: 'stylesheet',
    type: 'text/css',
    href: "<%= MagicBellRails.widget_css_url %>"
  }).appendTo('head');
  $(document).ready(function () {
    // Initialize MagicBell after the script is fetched
    $.getScript("<%= MagicBellRails.widget_javascript_url %>", initializeMagicBell);
  });
  function initializeMagicBell() {
    MagicBell.initialize({
      // Choose where you'd like the MagicBell widget to appear
      // Our customers usually use a div containing a bell icon as the target
      target: document.getElementById('mb-widget-placeholder'),
      projectId: "<%= MagicBellRails.project_id %>",
      apiKey: "<%= MagicBellRails.api_key %>",
      userEmail: "<%= current_user.email %>",
      userKey: "<%= MagicBellRails.user_key(current_user.email) %>"
    });
  }
</script>
```

Render the `_magicbell.html.erb` partial in your app's layout. Say, your app's layout file is `config/layous/app.html.erb`, render the partial at the bottom. Here's an example

```erb
<html>
  <body>
    <p>This is your app's layout</p>
  </body>
  <%= render layouts/magicbell %>
</html>
```

Now, call the `ring_the_magicbell` method in your notification mailers. Here's an example

```ruby
class NotificationMailer < ActionMailer::Base
  # This method will bcc your email notifications to your magicbell magic address
  #
  # Upon receiving the bcc'ed email notifications, magicbell.io will automatically
  # create in-app notications for users
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

That's it! All your users now benefit from having in-app notifications.

If you have trouble adding MagicBell to your app or find yourself stuck, please don't hestitate to reach out to us at hana@magicbell.io We usually respond within 24 hours (often much lesser).

## Advanced Features

#### Metadata

Its possible to attach custom metadata to every notification. Say you wish to attach a comment's id to a new comment notification, here's how it can be done

```ruby
class NotificationMailer < ActionMailer::Base
  ring_the_magicbell

  def new_comment(comment)
    # ...
    @magicbell_metadata = {
      comment_id: comment.id
    }
    # ...
  end
end
```

You'll be able to use this metadata to customize the behaviour of MagicBell's widget.

#### Customize widget behaviour

When a user clicks on a notification in MagicBell's widget, the widget redirects the user to the first link in the body of the email notification. If this behaviour isn't suitable for your app, you can customize it.

When initializing the widget, pass a `onNotificationClick` callback

```erb
<!-- MagicBell widget -->
<script>
  $('<link/>', {
     rel: 'stylesheet',
     type: 'text/css',
     href: <%= MagicBellRails.css_url %>
  }).appendTo('head');
  $(document).ready(function () {
    // Initialize MagicBell after the script is fetched
    $.getScript(<%= MagicBellRails.javascript_url %>, initializeMagicBell);
  });
  function initializeMagicBell() {
    MagicBell.initialize({
      target: document.getElementById('mb-widget-placeholder'), // Let us know where you've place your notification icon
      projectId: "<%= MagicBellRails.project_id %>",
      apiKey: "<%= MagicBellRails.api_key %>",
      userEmail: <%= current_user.email %>,
      userKey: "<%= MagicBellRails.user_key(current_user.email) %>",
      onNotificationClick: function (notification) {
	    // navigateToComment is a function defined in your app that takes your user to a specific comment
        navigateToComment(notification.get("metadata").comment_id)
      }
    });
  }
</script>
```

We'll be adding more callbacks to the widget as we receive feedback.

You'll find more information about MagicBell, MagicBell's widget and Advanced Features in our [Docs Site](https://magicbell.supportbee.com/149-magicbell-s-help-docs)