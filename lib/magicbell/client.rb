module MagicBell
  class Client
    include ApiOperations

    def create_notification(notification_attributes)
      MagicBell::Notification.create(self, notification_attributes)
    end

    # def user(user_id)
    #   MagicBell::User.find(user_id)
    # end

    def user_with_email(email)
      client = self
      MagicBell::User.new(client, "email" => email)
    end

    def authentication_headers
      MagicBell.authentication_headers
    end
  end
end
