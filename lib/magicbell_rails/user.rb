require 'faraday'

module MagicBellRails
  class User

    attr_accessor :email
    
    def initialize(attributes)
      @attributes = attributes
      @email = @attributes[:email]
      @conn = Faraday.new({
        url: MagicBellRails.api_host, 
        headers: MagicBellRails.project_specific_headers.merge(
          'X-MAGICBELL-USER-EMAIL' => @email
        )
      })
    end

    def notifications
      response = @conn.get "/notifications.json"
      JSON.parse(response.body)["notifications"]
    end
  end
end