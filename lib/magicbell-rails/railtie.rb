require "magicbell-rails/action_mailer_extension"

module MagicBellRails
  class Railtie < Rails::Railtie
    initializer 'magicbell-rails' do
      ActionController::Base.send :extend, MagicBellRails::ActionMailerExtension
    end
  end
end
