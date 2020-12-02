module MagicBell
  class UserNotificationsSeen < SingletonApiResource
    def path
      "/notifications/seen"
    end
  end
end
