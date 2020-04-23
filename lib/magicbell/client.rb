require "magicbell/client/notifications"

module MagicBell
  class Client
    include MagicBell::Client::Notifications

    # Returns an authenticated connection object which can be
    # used to make requests
    def connection
      @connection ||= Faraday.new(url: MagicBell.api_host)
    end
  end
end
