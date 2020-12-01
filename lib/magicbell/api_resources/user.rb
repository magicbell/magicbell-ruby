module MagicBell
  class User < ApiResource
    class << self
      def with_email(email)
        user = new("email" => email)
        user.retrieve
        user
      end
    end

    def email
      attributes["email"]
    end

    def path
      if id
        self.class.path + "/#{id}"
      elsif email
        self.class.path + "/email:#{email}"
      end
    end
  end
end
