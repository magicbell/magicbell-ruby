module MagicBell
  class Config
    attr_accessor :api_key
    attr_accessor :api_secret
    attr_accessor :project_id
    attr_accessor :magic_address
    attr_accessor :api_host

    def initialize
      @api_host = "https://api.magicbell.io"
    end
  end
end
