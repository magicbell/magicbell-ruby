require 'active_support'

describe MagicBell::User do

    let(:user) { MagicBell::User.new(email: 'hana@magicbell.io') }

    it "should be not throw an error on init" do
      expect(user.email).to eq 'hana@magicbell.io'
    end

    describe ".user_key" do

      it "calculates the user key for the given user's email" do
        expect(user.hmac_signature).to eq 'JOOgQ6zGwBwZDGfRN39ZMZGSVx9BwTOpY6B5lbWO6u0='
      end
    end

    describe "API " do

      let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
      let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }


      it "should fetch notifications for the user" do
        #expect(stub).to have_been_requested.times(1)
        stubs.get("/notifications.json") do |env|
          [
            200,
            Hash.new,
            '{"user":{"id":39},"project_id":11,"unseen_count":0,"total":70,"per_page":15,"total_pages":5,"current_page":1,"notifications":[{"id":4997,"title":"RE: Whitelisting for META Communication","action_url":null,"meta_data":"{\"ticket_id\":26258679,\"reply_id\":18135139}","seen_at":1583234384,"sent_at":1583233650,"read_at":null},{"id":4228,"title":"RE: Whitelisting for META Communication","action_url":null,"meta_data":"{\"ticket_id\":26258679,\"reply_id\":18135005}","seen_at":1583233068,"sent_at":1583232532,"read_at":null}]}'  
          ]
        end
        allow(Faraday).to receive(:new).and_return(conn)
        expect(user.notifications.count).to eq 2
        stubs.verify_stubbed_calls
      end

      it "should fetch preferences of the user" do
        stubs.get("/notification_preferences.json") do |env|
          [
            200,
            Hash.new,
            '{"notification_preferences":{"new_ticket":{"email":false,"in_app":true}}}'
          ]
        end
        allow(Faraday).to receive(:new).and_return(conn)
        expect(user.notification_preferences).to eq( {"new_ticket"=>{"email"=>false, "in_app"=>true}})
        stubs.verify_stubbed_calls
      end

      it "should set the notification preferences" do
        stubs.put("/notification_preferences.json",
          {:notification_preferences=>{"new_ticket"=>{"email"=>false, "in_app"=>true}}}
          ) {|env| [200, Hash.new, '']}
        allow(Faraday).to receive(:new).and_return(conn)
        user.notification_preferences = {"new_ticket"=>{"email"=>false, "in_app"=>true}}
        stubs.verify_stubbed_calls
      end
    end
end