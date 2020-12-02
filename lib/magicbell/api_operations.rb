module MagicBell
  module ApiOperations
    def get(url, options = {})
      HTTParty.get(
        url,
        options.merge(headers: authentication_headers)
      )
    end

    def post(url, options = {})
      HTTParty.post(
        url,
        options.merge(headers: authentication_headers)
      )
    end

    def put(url, options = {})
      HTTParty.put(
        url,
        options.merge(headers: authentication_headers)
      )
    end
  end
end