require "json"

module MagicBell
  module ActionMailerExtension
    def magicbell_notification_action_url(action_url)
      headers["X-MagicBell-Notification-ActionUrl"] = action_url
    end

    def magicbell_notification_metadata(metadata)
      headers["X-MagicBell-Notification-Metadata"] = metadata.to_json
    end

    def magicbell_notification_title(title)
      headers["X-MagicBell-Notification-Title"] = title
    end

    def magicbell_notification_skip
      headers["X-MagicBell-Notification-Skip"] = true
    end
  end

  def self.max_network_reties
    # code here
  end
end
