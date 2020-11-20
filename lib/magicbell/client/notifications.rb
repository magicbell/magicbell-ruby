module MagicBell
  class Client
    module Notifications
      # Creates a notification for a given project
      #
      # @param to [String] Email of a user for this notification
      # @param title [String] Title of the notification
      # @param content [String] Content of the notification
      # @param action_url [String] Url to redirect to from widget
      def create_notification(to, title, content, action_url)
        params = {
          to: to,
          title: title,
          content: content,
          action_url: action_url
        }

        connection.post("/notifications.json") do |req|
          req.headers = { "X-MAGICBELL-API-SECRET" => MagicBell.api_secret }
          req.body = { notification: params }
        end
      end
    end
  end
end
