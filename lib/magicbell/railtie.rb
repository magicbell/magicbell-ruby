require "rails/railtie"
require "magicbell/action_mailer_extension"

module MagicBell
  class Railtie < Rails::Railtie
    initializer 'magicbell' do
      ActionMailer::Base.send :include, MagicBell::ActionMailerExtension
    end
  end
end
