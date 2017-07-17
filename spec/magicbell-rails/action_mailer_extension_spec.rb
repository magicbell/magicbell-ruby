require "action_mailer"

describe MagicBellRails::ActionMailerExtension do
  describe "Helper methods" do
    let(:custom_action_url) { "https://myapp.com/comments/1" }
    let(:metadata) { { comment_id: 1 } }
    let(:custom_title) { "I'd like to have a title that is different from the email's subject" }
    let(:notification_mailer) {
      Class.new(ActionMailer::Base) do
        include MagicBellRails::ActionMailerExtension

        def new_comment
          mail(
            from: "notifications@mydummyapp.com",
            to: "dummycustomer@example.com",
            subject: "Just a dummy notification",
            body: "Just a dummy notification"
          )
          custom_action_url = "https://myapp.com/comments/1"
          magicbell_notification_action_url(custom_action_url)
          magicbell_notification_metadata(comment_id: 1)
          custom_title = "I'd like to have a title that is different from the email's subject"
          magicbell_notification_title(custom_title)
        end

        def reaching_monthly_limit
          mail(
            from: "notifications@mydummyapp.com",
            to: "dummycustomer@example.com",
            subject: "Just a dummy notification",
            body: "Just a dummy notification"
          )
          magicbell_notification_skip
        end
      end
    }

    describe "#magicbell_notification_action_url" do
      it "adds the 'X-MagicBell-Notification-ActionUrl' header" do
        mail = notification_mailer.new_comment
        expect(mail["X-MagicBell-Notification-ActionUrl"].decoded).to eq(custom_action_url)
      end
    end

    describe "#magicbell_notification_metadata" do
      it "adds the 'X-MagicBell-Notification-Metadata' header" do
        mail = notification_mailer.new_comment
        expect(mail["X-MagicBell-Notification-Metadata"].decoded).to eq(metadata.to_json)
      end
    end

    describe "#magicbell_notification_title" do
      it "adds the 'X-MagicBell-Notification-Title' header" do
        mail = notification_mailer.new_comment
        expect(mail["X-MagicBell-Notification-Title"].decoded).to eq(custom_title)
      end
    end

    describe "#magicbell_notification_skip" do
      it "adds the 'X-MagicBell-Notification-Skip' header" do
        mail = notification_mailer.reaching_monthly_limit
        expect(mail["X-MagicBell-Notification-Skip"].decoded).to eq("true")
      end
    end
  end
end
