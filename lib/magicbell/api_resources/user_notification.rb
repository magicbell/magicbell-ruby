module MagicBell
  class UserNotification < UserApiResource
    class << self
      def path
        "/notifications"
      end
    end

    def path
      "/notifications/#{id}"
    end

    # def mark_as_read
    #   UserNotificationRead.new("user_notification" => self).create
    # end

    # def mark_as_unread
    #   UserNotificationUnread.new("user_notification" => self).create
    # end
  end
end
