require "active_support/inflector"
require "json"

module MagicBell
  class ApiResource
    class << self
      def create(attributes = {})
        new(attributes).create
      end

      def name
        to_s.demodulize.underscore
      end

      def create_path
        "/#{name}s"
      end

      def create_url
        MagicBell.api_host + create_path
      end
    end

    attr_reader :id

    def initialize(attributes)
      @attributes = attributes
      @id = @attributes["id"]
      @loaded = false
    end

    def attributes
      load_unless_loaded
      @attributes
    end
    alias_method :to_h, :attributes

    def load
      response = HTTParty.get(
        url,
        headers: authentication_headers
      )
      parse_response(response)

      self
    end

    def name
      self.class.name
    end

    def create_url
      MagicBell.api_host + create_path
    end

    def create_path
      "/#{name}s"
    end

    def url
      MagicBell.api_host + path
    end

    def path
      "/#{name}s/#{id}"
    end

    def create
      response = HTTParty.post(
        create_url,
        body: { name => attributes }.to_json,
        headers: authentication_headers
      )
      parse_response(response)

      self
    end

    def update(new_attributes = {})
      response = HTTParty.put(
        url,
        body: new_attributes.to_json,
        headers: authentication_headers
      )
      parse_response(response)

      self
    end

    protected

    def authentication_headers
      MagicBell.authentication_headers
    end

    private

    attr_reader :response,
                :response_hash
    
    def load_unless_loaded
      return unless id # Never load a new unsaved resource
      return if @loaded
      load
    end

    def parse_response(response)
      @response = response
      unless response.code == 204
        @response_hash = JSON.parse(@response.body)
        @attributes = @response_hash[name]
      end
      @loaded = true
    end
  end
end
