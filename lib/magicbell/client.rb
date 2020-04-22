require 'jwt'
require "magicbell/client/notifications"

module MagicBell
  class Client
    include MagicBell::Client::Notifications

    # Initialize the client with email and role.
    #
    # @param email [String] Email of a member or a recipient
    # @param role [String] Role of email user, member|recipient
    def initialize(email, role)
      @email = email
      @role = role
    end

    attr_reader :email, :role

    # Returns the token that can be used with APIs
    #
    # @return [String] token to be used with APIs
    def api_token
      data = {sub: email, projectId: MagicBell.project_id, role: role}
      JWT.encode(data, MagicBell.api_secret, "HS256")
    end

    # Returns an authenticated connection object which can be
    # used to make requests
    def connection
      @connection ||=
        begin
          headers = {'Authorization' => ("token" + " " + api_token)}
          Faraday.new(url: MagicBell.api_host,
                      headers: headers)
        end
    end
  end
end
