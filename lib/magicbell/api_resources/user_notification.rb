# frozen_string_literal: true

module MagicBell
  class UserNotification < ApiResource
    class << self
      def path
        '/notifications'
      end
    end

    def path
      "/notifications/#{id}"
    end

    def mark_as_read
      UserNotificationRead.new(@client, 'user_notification' => self).create
    end

    def mark_as_unread
      UserNotificationUnread.new(@client, 'user_notification' => self).create
    end
  end
end
