# frozen_string_literal: true

require "spec_helper"

describe MagicBell::Client do
  let(:api_key) { "dummy_api_key" }
  let(:api_secret) { "dummy_api_secret" }
  let(:api_host) { "https://api.magicbell.io" }
  let(:user_email) { "joe@example.com" }
  let(:user_external_id) { "2acb4ac3-8a32-408a-a057-194dfbe89126" }
  let(:headers) {
    {
      "X-MAGICBELL-API-KEY" => api_key,
      "X-MAGICBELL-API-SECRET" => api_secret,
      "Content-Type" => "application/json",
      "Accept" => "application/json",
    }
  }
  let(:user_authentication_headers) { headers.merge("X-MAGICBELL-USER-EMAIL" => user_email) }

  def base64_decode(base64_decoded_string)
    Base64.decode64(base64_decoded_string)
  end

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

      let(:title) { "Welcome to Muziboo" }
      let(:body) do
        {
          "notification" => {
            "title" => title
          }
        }.to_json
      end
      let(:magicbell) { MagicBell::Client.new }

      context("and there is no response body") do
        before do
          stub_request(:post, notifications_url).with(headers: headers, body: body).and_return(status: 422)
        end

        it "raises an error" do
          exception_thrown = nil
          begin
            magicbell.create_notification(title: title)
          rescue MagicBell::Client::HTTPError => e
            exception_thrown = e
          end

          expect(exception_thrown.response_status).to eq(422)
          expect(exception_thrown.response_headers).to eq({})
          expect(exception_thrown.response_body).to eq("")
        end
      end

      context("and there is a response body with an errors block") do
        let(:response_body) do
          {
            "errors"=>
            [
              {
                "code" => "api_secret_not_provided",
                "suggestion" => "Please provide the 'X-MAGICBELL-API-SECRET' header containing your MagicBell project's API secret. Alternatively, if you intend to use MagicBell's API in JavaScript in your web application's frontend, please provide the 'X-MAGICBELL-USER-EMAIL' header containing a user's email and the 'X-MAGICBELL-USER-HMAC' containing the user's HMAC.",
                "message" => "API Secret not provided",
                "help_link" => "https://developer.magicbell.io/reference#authentication"
              }
            ]
          }.to_json
        end

        before do
          stub_request(:post, notifications_url).with(headers: headers, body: body).and_return(status: 422, body: response_body)
        end

        it "raises and displays an error" do
          exception_thrown = nil
          begin
            magicbell.create_notification(title: title)
          rescue MagicBell::Client::HTTPError => e
            exception_thrown = e
          end

          expect(exception_thrown.response_status).to eq(422)
          expect(exception_thrown.response_headers).to eq({})
          expect(exception_thrown.response_body).to eq(response_body)
          expect(exception_thrown.errors.length).to eq(1)
        end
      end

      context("and there is a response body with no errors block") do
        let(:response_body) { {}.to_json }

        before do
          stub_request(:post, notifications_url).with(headers: headers, body: body).and_return(status: 422, body: response_body)
        end

        it "raises and displays an error" do
          exception_thrown = nil
          begin
            magicbell.create_notification(title: title)
          rescue MagicBell::Client::HTTPError => e
            exception_thrown = e
          end

          expect(exception_thrown.response_status).to eq(422)
          expect(exception_thrown.response_headers).to eq({})
          expect(exception_thrown.response_body).to eq(response_body)
          expect(exception_thrown.errors.length).to eq(0)
        end
      end

      context("and there is a response body with with a nonarray errors block") do
        let(:response_body) { { "errors" => "testing 1234" }.to_json }

        before do
          stub_request(:post, notifications_url).with(headers: headers, body: body).and_return(status: 422, body: response_body)
        end

        it "raises and displays an error" do
          exception_thrown = nil
          begin
            magicbell.create_notification(title: title)
          rescue MagicBell::Client::HTTPError => e
            exception_thrown = e
          end

          expect(exception_thrown.response_status).to eq(422)
          expect(exception_thrown.response_headers).to eq({})
          expect(exception_thrown.response_body).to eq(response_body)
          expect(exception_thrown.errors.length).to eq(0)
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

    context "when the user is identified by external_id" do
      let(:user_authentication_headers) { headers.merge("X-MAGICBELL-USER-EXTERNAL-ID" => user_external_id) }

      it "can fetch a user's notifications" do
        magicbell = MagicBell::Client.new
        user = magicbell.user_with_external_id(user_external_id)

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

    context "when the user is identified by email" do
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
        "Accept" => "application/json",
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

  describe "API key and API secret configuration" do
    let(:client_api_key) { 'client_api_key' }
    let(:client_api_secret) { 'client_api_secret' }

    context "No API key and API secret provided" do
      it "keeps the global headers" do
        magicbell = MagicBell::Client.new

        expect(magicbell.authentication_headers).to eq("X-MAGICBELL-API-KEY" => api_key, "X-MAGICBELL-API-SECRET" => api_secret)
      end
    end

    context "API key and API key provided" do
      it "overrides the global headers with the project headers" do
        magicbell = MagicBell::Client.new(api_key: client_api_key, api_secret: client_api_secret)

        expect(magicbell.authentication_headers).to eq("X-MAGICBELL-API-KEY" => client_api_key, "X-MAGICBELL-API-SECRET" => client_api_secret)
      end
    end
  end

  describe "#hmac" do
    let(:client_api_key) { 'client_api_key' }
    let(:client_api_secret) { 'client_api_secret' }

    context "Using the global API secret" do
      it "calculates the hmac for the given string" do
        magicbell = MagicBell::Client.new
        hmac = magicbell.hmac(user_email)
        sha256_digest = OpenSSL::Digest.new('sha256')

        expect(base64_decode(hmac)).to eq(OpenSSL::HMAC.digest(sha256_digest, api_secret, user_email))
      end
    end

    context "Using the client API secret" do
      it "calculates the hmac for the given string" do
        magicbell = MagicBell::Client.new(api_key: client_api_key, api_secret: client_api_secret)
        hmac = magicbell.hmac(user_email)
        sha256_digest = OpenSSL::Digest.new('sha256')

        expect(base64_decode(hmac)).to eq(OpenSSL::HMAC.digest(sha256_digest, client_api_secret, user_email))
      end
    end
  end
end
