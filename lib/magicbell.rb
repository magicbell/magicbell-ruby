require 'forwardable'

require "openssl"
require "base64"

require "magicbell/config"

require "httparty"
require "magicbell/api_operations"
require "magicbell/client"
require "magicbell/api_resource"
require "magicbell/singleton_api_resource"
require "magicbell/api_resource_collection"
require "magicbell/api_resources/notification"
require "magicbell/api_resources/user"
require "magicbell/api_resources/user_notification"
require "magicbell/api_resources/user_notifications"
require "magicbell/api_resources/user_notification_read"
require "magicbell/api_resources/user_notification_unread"
require "magicbell/api_resources/user_notifications_read"
require "magicbell/api_resources/user_notifications_seen"
require "magicbell/api_resources/user_notification_preferences"

require "magicbell/railtie" if defined?(Rails)

module MagicBell
  WIDGET_JAVASCRIPT_URL = "https://assets.magicbell.io/widget.magicbell.js"
  EXTRAS_CSS_URL = "https://assets.magicbell.io/extras.magicbell.css"

  class << self
    extend Forwardable

    def_delegators :config, :api_key,
                            :api_secret,
                            :api_host

    def configure
      yield(config)
    end

    def config
      @config ||= Config.new
    end

    def reset_config
      @config = Config.new
    end

    def authentication_headers
      {
        "X-MAGICBELL-API-KEY" => api_key,
        "X-MAGICBELL-API-SECRET" => api_secret
      }
    end

    # Calculate HMAC for user's email
    def hmac(message)
      digest = sha256_digest
      secret = api_secret

      Base64.encode64(OpenSSL::HMAC.digest(digest, secret, message)).strip
    end

    private

    def sha256_digest
      OpenSSL::Digest::Digest.new('sha256')
    end
  end
end
