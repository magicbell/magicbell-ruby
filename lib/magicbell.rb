require "magicbell/config"
require "magicbell/hmac"
require "magicbell/user"
require "magicbell/railtie" if defined?(Rails)

require 'forwardable'


module MagicBell
  WIDGET_JAVASCRIPT_URL = "https://assets.magicbell.io/widget.magicbell.js"
  EXTRAS_CSS_URL = "https://assets.magicbell.io/extras.magicbell.css"

  class << self
    extend Forwardable

    def_delegators :@config, :api_key, :api_secret, :project_id, :magic_address, :api_host

    def configure
      yield(config)
    end

    def config
      @config ||= Config.new
    end

    def reset_config
      @config = nil
    end

    def project_specific_headers
      {
        'X-MAGICBELL-API-KEY' => config.api_key,
        'X-MAGICBELL-API-SECRET' => config.api_secret
      }
    end

    # Calculate HMAC for user's email
    def user_key(user_email)
      MagicBell::HMAC.calculate(user_email, MagicBell.api_secret)
    end
  end
end
