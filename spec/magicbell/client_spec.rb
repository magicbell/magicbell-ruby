require "spec_helper"

describe MagicBell::Client do
  let(:api_key) { "dummy_api_key" }
  let(:api_secret) { "dummy_api_secret" }
  let(:api_host) { "https://api.magicbell.io" }
  let(:user_email) { "joe@example.com" }
  let(:headers) {
    {
      "X-MAGICBELL-API-KEY" => api_key,
      "X-MAGICBELL-API-SECRET" => api_secret,
      "Content-Type" => "application/json",
    }
  }
  let(:user_authentication_headers) { headers.merge("X-MAGICBELL-USER-EMAIL" => user_email) }

  before(:each) do
    ENV["MAGICBELL_API_KEY"] = api_key
    ENV["MAGICBELL_API_SECRET"] = api_secret

    WebMock.enable!
  end

  describe "#create_notification" do
    let(:notifications_url) { api_host + "/notifications" }

    context "when recipient is identified by email" do
      it "creates a notification" do
        body = {
          "notification" => {
            "title" => "Welcome to Muziboo",
            "recipients" => [{
              "email" => "john@example.com"
            }]
          }
        }.to_json
        stub_request(:post, notifications_url).with(headers: headers, body: body).and_return(status: 201, body: "{}")
        magicbell = MagicBell::Client.new
        magicbell.create_notification(
          title: "Welcome to Muziboo",
          recipients: [{
            email: "john@example.com"
          }]
        )
      end
    end
    
    context "when recipient is identified by external_id" do
      it "creates a notification" do
        body = {
          "notification" => {
            "title" => "Welcome to Muziboo",
            "recipients" => [{
              "external_id" => "id_in_your_database"
            }]
          }
        }.to_json
        stub_request(:post, notifications_url).with(headers: headers, body: body).and_return(status: 201, body: "{}")
        magicbell = MagicBell::Client.new
        magicbell.create_notification(
          title: "Welcome to Muziboo",
          recipients: [{
            external_id: "id_in_your_database"
          }]
        )
      end
    end

    context "API response was not a 2xx response" do
      it "raises an error" do
        body = {
          "notification" => {
            "title" => "Welcome to Muziboo"
          }
        }.to_json
        stub_request(:post, notifications_url).with(headers: headers, body: body).and_return(status: 422)
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

  describe "Mark a user notification as read" do
    let(:notification_id) { "dummy_notification_id" }
    let(:notification_url) { "#{api_host}/notifications/#{notification_id}" }
    let(:notification_read_url) { "#{notification_url}/read" }

    it "can mark a user notification as read" do
      magicbell = MagicBell::Client.new
      user = magicbell.user_with_email(user_email)
      response_body = {
        "notification" => {
          "id" => "notification_id"
        }
      }.to_json
      stub_request(:get, notification_url).with(headers: user_authentication_headers).and_return(status: 200, body: response_body)
      user_notification = user.find_notification(notification_id)
      stub_request(:post, notification_read_url).with(headers: user_authentication_headers).and_return(status: 204)
      user_notification.mark_as_read
    end
  end

  describe "Fetching a user's notifications" do
    let("notifications_url") { "#{api_host}/notifications" }

    it "can fetch a user's notifications" do
      magicbell = MagicBell::Client.new
      user = magicbell.user_with_email(user_email)
      response_body = {
        "notifications" => [
          {
            "id" => "a",
          },
          {
            "id" => "b"
          }
        ]
      }.to_json
      fetch_notifications_request = stub_request(:get, notifications_url).with(headers: user_authentication_headers).and_return(status: 200, body: response_body)
      user.notifications.each { |notification| notification.attribute("title") }
      assert_requested(fetch_notifications_request)
    end
  end

  describe "Mark a user notification as unread" do
    let(:notification_id) { "dummy_notification_id" }
    let(:notification_url) { "#{api_host}/notifications/#{notification_id}" }
    let(:notification_read_url) { "#{notification_url}/unread" }

    it "can mark a user notification as unread" do
      magicbell = MagicBell::Client.new
      user = magicbell.user_with_email(user_email)
      response_body = {
        "notification" => {
          "id" => "notification_id"
        }
      }.to_json
      fetch_notification_request = stub_request(:get, notification_url).with(headers: user_authentication_headers).and_return(status: 200, body: response_body)
      user_notification = user.find_notification(notification_id)
      mark_notification_as_read_request = stub_request(:post, notification_read_url).with(headers: user_authentication_headers).and_return(status: 204)
      user_notification.mark_as_unread

      assert_requested(fetch_notification_request)
      assert_requested(mark_notification_as_read_request)
    end
  end

  describe "Mark all user notifications as read" do
    let(:notifications_read_url) { "#{api_host}/notifications/read" }

    it "can mark all of a user's notifications as read" do
      magicbell = MagicBell::Client.new
      user = magicbell.user_with_email(user_email)
      mark_all_notifications_as_read_request = stub_request(:post, notifications_read_url).with(headers: user_authentication_headers).and_return(status: 204)
      user.mark_all_notifications_as_read
      assert_requested(mark_all_notifications_as_read_request)
    end
  end

  describe "Mark all user notifications as seen" do
    let(:notifications_seen_url) { "#{api_host}/notifications/seen" }

    it "can mark all of a user's notifications as seen" do
      magicbell = MagicBell::Client.new
      user = magicbell.user_with_email(user_email)
      mark_all_notification_as_seen_request = stub_request(:post, notifications_seen_url).with(headers: user_authentication_headers).and_return(status: 204)
      user.mark_all_notifications_as_seen
      assert_requested(mark_all_notification_as_seen_request)
    end
  end

  describe "Configuration" do
    it "is also configurable in an initializer" do
      ENV.delete("MAGICBELL_API_KEY")
      ENV.delete("MAGICBELL_API_SECRET")
      WebMock.enable!

      MagicBell.configure do |config|
        config.api_key = api_key
        config.api_secret = api_secret
      end

      headers = {
        "X-MAGICBELL-API-KEY" => api_key,
        "X-MAGICBELL-API-SECRET" => api_secret,
        "Content-Type" => "application/json",
      }
      body = {
        "notification" => {
          "title" => "Welcome to Muziboo",
          "recipients" => [{
            "email" => "john@example.com"
          }]
        }
      }.to_json
      stub_request(:post, "#{api_host}/notifications").with(headers: headers, body: body).and_return(status: 201, body: "{}")

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
