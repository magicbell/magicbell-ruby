require "magicbell/config"
require "magicbell/hmac"
require "magicbell/user"


module MagicBell
  CLOUDFRONT_DOMAIN = "dxd8ma9fvw6e2.cloudfront.net"

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

    def extras_css_url
      "//#{CLOUDFRONT_DOMAIN}/extras.magicbell.css"
    end
    alias_method :host_page_css_url, :extras_css_url # Backward compatibility

    def api_host
      config.api_host
    end

    def widget_javascript_url
      "//#{CLOUDFRONT_DOMAIN}/widget.magicbell.js"
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
