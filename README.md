# magicbell-rails

This gem makes it easy to add [MagicBell's](https://magicbell.io/) notification center widget to your rails app.

## Installation

Add the magicbell gem to your app's Gemfile

```
gem "magicbell"
```

Run

```
bundle install
```

Create the initializer file `config/initializers/magicbell-rails.rb` and add your MagicBell credentials there.

```
vim config/initializers/magicbell-rails.rb
```

```
MagicBellRails.configure do |config|
  config.api_key = "your_magicbell_api_key"
  config.api_secret = "your_magicbell_api_secret"
  config.project_id = 1 # your magicbell project id
  config.magic_address = "your_magicell_magic_address@ring.magicbell.io"
end
```

If you haven't yet signed up for MagicBell and don't have credentials, sign up [here](https://magicbell.io/)

Create the partial file `config/layouts/_magicbell.html.erb` and copy paste the code below

```
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
      userKey: "<%= MagicBellRails.user_key(current_user.email) %>"
    });
  }
</script>
```

Render the `_magicbell.html.erb` partial in your app's layout. Say, your app's layout file is `config/layous/app.html.erb`, render the partial at the bottom. Here's an example

```
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

If you have trouble adding MagicBell to your app, please reach out to us immediately at hana@magicbell.io

