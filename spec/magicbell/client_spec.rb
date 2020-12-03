require "spec_helper"

describe MagicBell::Client do
  let(:api_key) { "dummy_api_key" }
  let(:api_secret) { "dummy_api_secret" }
  let(:api_host) { "https://api.magicbell.io/notifications" }
  let(:headers) {
    {
      "X-MAGICBELL-API-KEY" => api_key,
      "X-MAGICBELL-API-SECRET" => api_secret
    }
  }

  describe "#create_notification" do
    before(:each) do
      ENV["MAGICBELL_API_KEY"] = api_key
      ENV["MAGICBELL_API_SECRET"] = api_secret

      WebMock.enable!
    end

    it "creates a notification" do
      body = {
        "notification" => {
          "title" => "Welcome to Muziboo",
          "recipients" => [{
            "email" => "john@example.com"
          }]
        }
      }.to_json
      stub_request(:post, api_host).with(headers: headers, body: body).and_return(status: 201, body: "{}")
      magicbell = MagicBell::Client.new
      magicbell.create_notification(
        title: "Welcome to Muziboo",
        recipients: [{
          email: "john@example.com"
        }]
      )
    end

    context "API response was not a 2xx response" do
      it "raises an error" do
        body = {
          "notification" => {
            "title" => "Welcome to Muziboo"
          }
        }.to_json
        stub_request(:post, api_host).with(headers: headers, body: body).and_return(status: 422)
        magicbell = MagicBell::Client.new
        expect do
          magicbell.create_notification(title: "Welcome to Muziboo")
        end.to raise_error(MagicBell::Client::HTTPError)
        begin
          magicbell.create_notification(title: "Welcome to Muziboo")
        rescue MagicBell::Client::HTTPError => e
          expect(e.response_status).to eq(422)
          expect(e.response_headers).to eq({})
          expect(e.response_body).to eq("")
        end
      end
    end
  end

  describe "Configuration" do
    it "is also configurable in an initializer" do
      MagicBell.configure do |config|
        config.api_key = api_key
        config.api_secret = api_secret
      end

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
      stub_request(:post, api_host).with(headers: headers, body: body).and_return(status: 201, body: "{}")
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
