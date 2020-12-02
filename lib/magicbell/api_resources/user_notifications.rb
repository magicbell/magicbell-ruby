module MagicBell
  class UserNotifications < ApiResourceCollection
    def name
      "notifications"
    end

    def path
      "/notifications"
    end

    def resource_class
      MagicBell::UserNotification
    end
  end
end
