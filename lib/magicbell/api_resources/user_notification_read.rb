# frozen_string_literal: true

module MagicBell
  class UserNotificationRead < SingletonApiResource
    attr_reader :user_notification

    def initialize(client, attributes)
      @user_notification = attributes.delete('user_notification')
      super(client, attributes)
    end

    def path
      user_notification.path + '/read'
    end
  end
end
