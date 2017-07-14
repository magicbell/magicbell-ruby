class MagicBellRails
  module ActionMailerExtension
    def ring_the_magicbell
      default bcc: MagicBell.configuration.magic_address
    end
  end
end
