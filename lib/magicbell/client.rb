module MagicBell
  class Client
    def create_notification(notification_params)
      MagicBell::Notification.create(notification_params)
    end
  end
end
