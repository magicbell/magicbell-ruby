# frozen_string_literal: true

require 'active_support/inflector'
require 'active_support/core_ext/object/blank'

module MagicBell
  class ApiResource
    class << self
      def create(client, attributes = {})
        new(client, attributes).create
      end

      def find(client, id)
        api_resource = new(client, 'id' => id)
        api_resource.retrieve
        api_resource
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

    def initialize(client, attributes = {})
      @client = client
      @attributes = attributes

      @id = @attributes['id']
      @retrieved = true if @id
    end

    def attributes
      retrieve_unless_retrieved
      @attributes
    end

    alias to_h attributes

    def attribute(attribute_name)
      attributes[attribute_name]
    end

    def retrieve
      @client.get(url)
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
      @client.post(
        create_url,
        body: { name => attributes }.to_json,
        headers: extra_headers
      )
    end

    def update(new_attributes = {})
      @client.put(
        url,
        body: new_attributes.to_json,
        headers: extra_headers
      )
    end

    protected

    def extra_headers
      {}
    end

    private

    attr_reader :response, :response_hash

    def retrieve_unless_retrieved
      return unless id # Never retrieve a new unsaved resource
      return if @retrieved

      retrieve
    end
  end
end
