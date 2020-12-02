module MagicBell
  class Client
    def create_notification(notification_params)
      MagicBell::Notification.create(notification_params)
    end

    # def user(user_id)
    #   MagicBell::User.find(user_id)
    # end

    def user_with_email(user_email)
      MagicBell::User.with_email(user_email)
    end
  end
end
