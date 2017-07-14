require "base64"

module MagicBellRails
  module HMAC
    class << self
      def calculate_hmac(message, hmac_key)
        digest  = OpenSSL::Digest::Digest.new('sha256')
        Base64.encode64(OpenSSL::HMAC.digest(digest, hmac_key, message)).strip
      end
    end
  end
end
