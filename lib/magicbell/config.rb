# frozen_string_literal: true

module MagicBell
  class Config
    attr_writer :api_key, :api_secret, :api_host, :max_network_retries

    def initialize
      @api_host = 'https://api.magicbell.io'
    end

    def api_key
      @api_key || ENV['MAGICBELL_API_KEY']
    end

    def api_secret
      @api_secret || ENV['MAGICBELL_API_SECRET']
    end

    def api_host
      @api_host || ENV['MAGICBELL_API_HOST'] || 'https://api.magicbell.io'
    end

    def max_network_retries
      @max_network_retries || 2
    end
  end
end
