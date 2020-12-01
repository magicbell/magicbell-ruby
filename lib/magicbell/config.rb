module MagicBell
  class Config
    attr_writer :api_key
    attr_writer :api_secret
    attr_writer :bcc_email
    attr_writer :api_host

    def initialize
      @api_host = "https://api.magicbell.io"
    end

    def api_key
      @api_key || ENV["MAGICBELL_API_KEY"]
    end

    def api_secret
      @api_secret || ENV["MAGICBELL_API_SECRET"]
    end

    def bcc_email
      @bcc_email || ENV["MAGICBELL_BCC_EMAIL"]
    end

    def api_host
      @api_host || ENV["MAGICBELL_API_HOST"]
    end
  end
end
