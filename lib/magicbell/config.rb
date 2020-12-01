module MagicBell
  class Config
    attr_writer :api_key
    attr_writer :api_secret
    attr_accessor :project_id
    attr_accessor :magic_address
    attr_accessor :api_host

    def initialize
      @api_host = "https://api.magicbell.io"
    end

    def api_key
      @api_key || ENV["MAGICBELL_API_KEY"]
    end

    def api_secret
      @api_secret || ENV["MAGICBELL_API_SECRET"]
    end
  end
end
