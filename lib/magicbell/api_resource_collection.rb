module MagicBell
  class ApiResourceCollection
    attr_reader :attributes

    def initialize(client, attributes = {})
      @client = client
      @attributes = attributes
      @loaded = false
    end

    # @todo Add examples
    def load(params = {})
      @response = @client.get(
        url,
        query: params
      )
      @response_hash = JSON.parse(response.body)
      @resources = response_hash[name].map { |resource_attributes| resource_class.new(@client, resource_attributes) }
      @loaded = true

      self
    end

    def to_a
      load_unless_loaded
      resources
    end

    def first
      load_unless_loaded
      resources.first
    end

    def url
      MagicBell.api_host + path
    end

    def authentication_headers
      MagicBell.authentication_headers
    end

    def current_page
      return unless response_hash
      response_hash["current_page"]
    end

    def total_pages
      return unless response_hash
      response_hash["total_pages"]
    end

    def per_page
      return unless response_hash
      response_hash["per_page"]
    end

    private

    attr_reader :response,
                :response_hash,
                :resources
    
    def load_unless_loaded
      return if @loaded
      load
    end
  end
end
