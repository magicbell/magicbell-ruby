module MagicBell
  class Client
    def api_url
      "https://api.magicbell.io"
    end

    def create_notification(notification_params)
      headers = {
        "X-MAGICBELL-API-KEY" => MagicBell.api_key,
        "X-MAGICBELL-API-SECRET" => MagicBell.api_secret
      }
      body = { notification: notification_params }.to_json
      HTTParty.post(
        notifications_url,
        headers: headers,
        body: body
      )
    end

    private

    def notifications_url
      api_url + "/notifications"
    end
  end
end
