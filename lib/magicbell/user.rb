require 'faraday'

module MagicBell
  class User

    attr_accessor :email
    attr_accessor :preferences
    
    def initialize(attributes)
      @attributes = attributes
      @email = @attributes[:email]
      @conn = Faraday.new({
        url: MagicBell.api_host, 
        headers: MagicBell.project_specific_headers.merge(
          'X-MAGICBELL-USER-EMAIL' => @email
        )
      })
    end

    def notifications
      response = @conn.get "/notifications.json"
      JSON.parse(response.body)["notifications"]
    end

    def hmac_signature
      MagicBell::HMAC.calculate @email
    end

    def notification_preferences
      response = @conn.get "/notification_preferences.json"
      JSON.parse(response.body)["notification_preferences"]
    end
    
    def notification_preferences=(preferences)
       @conn.put "/notification_preferences.json", 
                    {notification_preferences: preferences}
    end
    
  end
end