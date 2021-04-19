require 'json'
require 'colorize'
require 'pp'
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
      authentication_headers.merge({ "Content-Type" => "application/json", "Accept"=> "application/json" })
    end

    private

    def raise_http_error_unless_2xx_response(response)
      return if response.success?
      
      e = MagicBell::Client::HTTPError.new
      e.response_status = response.code
      e.response_headers = response.headers.to_h
      e.response_body = response.body
      body = JSON.parse(response.body)
      e.errors = body["errors"]
      e.errors.each do |error, index|
        puts "#{error["suggestion"].red}"
        puts "#{error["help_link"].blue.on_white}"
      end
      raise e
    end
  end
end
