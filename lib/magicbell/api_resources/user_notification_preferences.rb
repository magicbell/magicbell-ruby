module MagicBell
  class UserNotificationPreferences < UserApiResource
    def name
      "notification_preferences"
    end

    def path
      "/notification_preferences"
    end
  end
end
