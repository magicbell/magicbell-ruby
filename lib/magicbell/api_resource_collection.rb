# frozen_string_literal: true

module MagicBell
  class ApiResourceCollection
    def initialize(client, query_params = {})
      @client = client
      @query_params = query_params
      @retrieved = false
    end

    # @todo Add examples
    def retrieve
      @response = @client.get(
        url,
        query: @query_params
      )
      @response_hash = JSON.parse(response.body)
      @resources = response_hash[name].map { |resource_attributes| resource_class.new(@client, resource_attributes) }
      @retrieved = true

      self
    end

    def to_a
      resources
    end

    def first
      resources.first
    end

    def url
      MagicBell.api_host + path
    end

    def authentication_headers
      MagicBell.authentication_headers
    end

    def each(&block)
      resources.each(&block)
    end

    def each_page
      current_page = self
      loop do
        yield(current_page)
        break if current_page.last_page?

        current_page = current_page.next_page
      end
    end

    def last_page?
      current_page == total_pages
    end

    def next_page
      self.class.new(@client, page: current_page + 1, per_page: per_page)
    end

    def current_page
      retrieve_unless_retrieved
      response_hash['current_page']
    end

    def total_pages
      retrieve_unless_retrieved
      response_hash['total_pages']
    end

    def per_page
      retrieve_unless_retrieved
      response_hash['per_page']
    end

    private

    attr_reader :response, :response_hash

    def resources
      retrieve_unless_retrieved
      @resources
    end

    def retrieve_unless_retrieved
      return if @retrieved

      retrieve
    end
  end
end
