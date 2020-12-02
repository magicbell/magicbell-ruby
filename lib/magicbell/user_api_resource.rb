module MagicBell
  class UserApiResource < ApiResource
    attr_reader :user

    def initialize(attributes)
      @user = attributes.delete("user")
      @attributes = attributes
    end

    def authentication_headers
      user.authentication_headers
    end
  end
end
