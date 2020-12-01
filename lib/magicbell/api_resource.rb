require "active_support/inflector"
require "json"

module MagicBell
  class ApiResource
    class << self
      def find(id)
        api_resource = new("id" => "id")
        api_resource.retrieve
        api_resource
      end

      def create(params)
        body = { name => params }.to_json
        HTTParty.post(
          url,
          headers: authentication_headers,
          body: body
        )
      end

      def name
        to_s.demodulize.underscore
      end

      def path
        "/#{name}s"
      end

      def url
        api_base_url + path
      end

      def api_base_url
        "https://api.magicbell.io"
      end

      def authentication_headers
        {
          "X-MAGICBELL-API-KEY" => MagicBell.api_key,
          "X-MAGICBELL-API-SECRET" => MagicBell.api_secret
        }
      end
    end

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def retrieve
      response = HTTParty.get(
        url,
        headers: authentication_headers
      )
      binding.pry
      response_hash = JSON.parse(response_hash)
      @attributes = response_hash[self.class.name]
    end

    def url
      self.class.api_base_url + path
    end

    def id
      attributes["id"]
    end

    def path
      self.class.path + "/{id}"
    end

    private

    def api_base_url
      self.class.api_base_url
    end

    def authentication_headers
      self.class.authentication_headers
    end
  end
end
