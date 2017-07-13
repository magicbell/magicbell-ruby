# magicbell

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

Create a config file `config/magicbell.yml` and add your MagicBell credentials there. 

```
vim config/magicbell.yml
```

```
---
api_key: "your_magicbell_api_key"
api_secret: "your_magicbell_api_secret"
project_id: 1 # Your magicbell project id
magic_address: "your_magicbell_magic_address"
```

If you haven't yet signed up for MagicBell and don't have credentials, contact us!

Call the `ring_the_magicbell` method in your notification mailers. Here's an example

```ruby
class NotificationMailer < ActionMailer::Base
  # This method will bcc your email notifications to your magicbell magic address
  #
  # Upon receiving the bcc'ed email notifications, magicbell.io will automatically
  # create in-app noti
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