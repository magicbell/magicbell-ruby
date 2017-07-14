require "magicbell-rails/config"
require "magicbell-rails/hmac"

module MagicBellRails
  CLOUDFRONT_DOMAIN = "dxd8ma9fvw6e2.cloudfront.net"

  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Config.new
    end

    def widget_css_url
      "//" + CLOUDFRONT_DOMAIN + '/magicbell.min.css'
    end

    def widget_javascript_url
      "//" + CLOUDFRONT_DOMAIN + '/magicbell.min.js'
    end

    def project_id
      config.project_id
    end

    def api_key
      config.api_key
    end

    def api_secret
      config.api_secret
    end

    # Calculate HMAC for user's email
    def user_key(user_email)
      MagicBellRails::HMAC.calculate_hmac(user_email, MagicBellRails.api_secret)
    end
  end
end
