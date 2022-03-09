module MagicBell
  class User < ApiResource
    include ApiOperations

    attr_reader :email, :external_id

    def initialize(client, attributes)
      @client = client
      @email = attributes['email']
      @external_id = attributes['external_id']

      super(client, attributes)
    end

    def notifications(query_params = {})
      client = self
      MagicBell::UserNotifications.new(client, query_params)
    end

    def find_notification(notification_id)
      client = self
      MagicBell::UserNotification.find(client, notification_id)
    end

    def mark_all_notifications_as_read
      client = self
      MagicBell::UserNotificationsRead.new(client).create
    end

    def mark_all_notifications_as_seen
      client = self
      MagicBell::UserNotificationsSeen.new(client).create
    end

    def notification_preferences
      client = self
      MagicBell::UserNotificationPreferences.new(client)
    end

    def path
      if id
        self.class.path + "/#{id}"
      elsif external_id
        self.class.path + "/external_id:#{external_id}"
      elsif email
        self.class.path + "/email:#{email}"
      end
    end

    def authentication_headers
      if external_id
        MagicBell.authentication_headers.merge('X-MAGICBELL-USER-EXTERNAL-ID' => external_id)
      elsif email
        MagicBell.authentication_headers.merge('X-MAGICBELL-USER-EMAIL' => email)
      end
    end
  end
end
