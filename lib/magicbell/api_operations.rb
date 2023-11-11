# frozen_string_literal: true

module MagicBell
  module ApiOperations
    def get(url, options = {})
      defaults = { headers: default_headers }
      HTTParty.get(url, options.merge(defaults))
    end

    def post(url, options = {})
      defaults = { headers: default_headers }
      HTTParty.post(url, options.merge(defaults))
    end

    def put(url, options = {})
      defaults = { headers: default_headers }
      HTTParty.put(url, options.merge(defaults))
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
  end
end
