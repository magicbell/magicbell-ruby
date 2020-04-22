require "magicbell/config"
require "magicbell/hmac"
require "magicbell/user"


module MagicBell
  WIDGET_JAVASCRIPT_URL = "https://assets.magicbell.io/widget.magicbell.js"
  EXTRAS_CSS_URL = "https://assets.magicbell.io/extras.magicbell.css"

  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Config.new
    end

    def reset_config
      @config = nil
    end

    def api_host
      config.api_host
    end

    def api_key
      config.api_key
    end

    def api_secret
      config.api_secret
    end

    def project_id
      config.project_id
    end

    def magic_address
      config.magic_address
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

require "magicbell/railtie"
