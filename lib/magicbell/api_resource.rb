require "active_support/inflector"

module MagicBell
  class ApiResource
    class << self
      def create(params)
        headers = {
          "X-MAGICBELL-API-KEY" => MagicBell.api_key,
          "X-MAGICBELL-API-SECRET" => MagicBell.api_secret
        }
        body = { name => params }.to_json
        HTTParty.post(
          url,
          headers: headers,
          body: body
        )
      end

      private

      def url
        api_base_url + path
      end

      def api_base_url
        "https://api.magicbell.io"
      end

      def path
        "/#{name}s"
      end

      def name
        to_s.demodulize.underscore
      end
    end
  end
end
