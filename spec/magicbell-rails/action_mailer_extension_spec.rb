require "action_mailer"

class NotificationMailer < ActionMailer::Base
  include MagicBellRails::ActionMailerExtension

  def new_comment
    mail(
      from: "notifications@mydummyapp.com",
      to: "dummycustomer@example.com",
      subject: "Just a dummy notification",
      body: "Just a dummy notification"
    )
    magicbell_notification_metadata(comment_id: 1)
  end
end

describe MagicBellRails::ActionMailerExtension do
  describe "Helper methods" do
    describe "#magicbell_notification_metadata" do
      it "does something" do
        mail = NotificationMailer.new_comment
        expect(mail["X-MagicBell-Notification-Metadata"].decoded).to eq({ comment_id: 1 }.to_json)
      end
    end
  end
end
