# frozen_string_literal: true

require 'json'

module MagicBell
  module ApiOperations
    def get(url, options = {})
      defaults = { headers: default_headers }
      response = HTTParty.get(url, options.merge(defaults))
      raise_http_error_unless_2xx_response(response)

      response
    end

    def post(url, options = {})
      defaults = { headers: default_headers }
      response = HTTParty.post(url, options.merge(defaults))
      raise_http_error_unless_2xx_response(response)

      response
    end

    def put(url, options = {})
      defaults = { headers: default_headers }
      response = HTTParty.put(url, options.merge(defaults))
      raise_http_error_unless_2xx_response(response)

      response
    end

    protected

    def default_headers
      authentication_headers.merge(
        {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      )
    end

    private

    def raise_http_error_unless_2xx_response(response)
      return if response.success?

      e = MagicBell::Client::HTTPError.new
      e.response_status = response.code
      e.response_headers = response.headers.to_h
      e.response_body = response.body
      e.errors = []
      if e.response_body.present?
        body = JSON.parse(response.body)
        e.errors = body['errors'].is_a?(Array) ? body['errors'] : []
        e.errors.each do |error, _index|
          suggestion = error['suggestion']
          help_link = error['help_link']

          puts suggestion if suggestion
          puts help_link if help_link
        end
      end

      raise e
    end
  end
end
