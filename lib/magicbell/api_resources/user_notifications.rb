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

    def user
      attributes["user"]
    end

    protected

    def authentication_headers
      user.authentication_headers
    end
  end
end
