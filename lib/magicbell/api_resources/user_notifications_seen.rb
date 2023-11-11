# frozen_string_literal: true

module MagicBell
  class UserNotificationsSeen < SingletonApiResource
    def path
      '/notifications/seen'
    end
  end
end
