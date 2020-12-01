require "spec_helper"

describe MagicBell::Client do
  def api_url
    "https://api.magicbell.io/notifications"
  end

  def api_key
    "dummy_api_key"
  end

  def api_secret
    "dummy_api_secret"
  end

  describe "#create_notification" do
    it "creates a notification" do
      WebMock.enable!
      headers = {
       "X-MAGICBELL-API-KEY" => api_key,
       "X-MAGICBELL-API-SECRET" => api_secret,
      }
      body = {
        "notification" => {
          "title" => "Welcome to Muziboo",
          "recipients" => [{
            "email" => "john@example.com"
          }]
        }
      }.to_json
      stub_request(:post, api_url).with(headers: headers, body: body)
      magicbell = MagicBell::Client.new
      magicbell.create_notification(
        title: "Welcome to Muziboo",
        recipients: [{
          email: "john@example.com"
        }]
      )
    end
  end
end
