module MagicBell
  class User < ApiResource
    class << self
      def with_email(email)
        new("email" => email)
      end
    end

    attr_reader :email

    def initialize(attributes)
      @email = attributes["email"]
      super(attributes)
    end

    def notifications(params = {})
      MagicBell::UserNotifications.new("user" => self)
    end

    def notification_preferences
      MagicBell::UserNotificationPreferences.new("user" => self)
    end

    def path
      if id
        self.class.path + "/#{id}"
      elsif email
        self.class.path + "/email:#{email}"
      end
    end

    def authentication_headers
      authentication_headers = super
      authentication_headers.merge("X-MAGICBELL-USER-EMAIL" => email)
    end
  end
end
