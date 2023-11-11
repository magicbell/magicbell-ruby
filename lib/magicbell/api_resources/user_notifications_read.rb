# frozen_string_literal: true

module MagicBell
  class UserNotificationsRead < SingletonApiResource
    def path
      '/notifications/read'
    end
  end
end
