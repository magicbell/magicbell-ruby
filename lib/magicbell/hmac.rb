require "openssl"
require "base64"

module MagicBell
  module HMAC
    class << self
      def calculate(message)
        digest = sha256_digest
        secret = MagicBell.api_secret

        Base64.encode64(OpenSSL::HMAC.digest(digest, secret, message)).strip
      end

      private

      def sha256_digest
        OpenSSL::Digest::Digest.new('sha256')
      end
    end
  end
end
