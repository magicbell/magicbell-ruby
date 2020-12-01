require "magicbell/config"
require "magicbell/hmac"

require "httparty"
require "magicbell/api_resource"
require "magicbell/api_resources/user"
require "magicbell/api_resources/notification"
require "magicbell/client"

require "magicbell/railtie" if defined?(Rails)

require 'forwardable'

module MagicBell
  WIDGET_JAVASCRIPT_URL = "https://assets.magicbell.io/widget.magicbell.js"
  EXTRAS_CSS_URL = "https://assets.magicbell.io/extras.magicbell.css"

  class << self
    extend Forwardable

    def_delegators :config, :api_key,
                            :api_secret,
                            :project_id,
                            :magic_address,
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

    # Calculate HMAC for user's email
    def user_email_hmac(user_email)
      MagicBell::HMAC.calculate(user_email, MagicBell.api_secret)
    end
  end
end
