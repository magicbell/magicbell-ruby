module MagicBellRails
  module ActionMailerExtension
    def ring_the_magicbell
      default bcc: MagicBellRails.magic_address
    end
  end
end
