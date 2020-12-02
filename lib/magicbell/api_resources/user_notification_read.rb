module MagicBell
  class UserNotificationRead < UserApiResource
    include SingletonApiResource

    attr_reader :user_notification

    def initialize(attributes)
      @user_notification = attributes.delete("user_notification")
    end

    def user
      user_notification.user
    end

    def path
      user_notification.path + "/read"
    end
  end
end
