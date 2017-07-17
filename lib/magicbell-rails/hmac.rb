require "openssl"
require "base64"

module MagicBellRails
  module HMAC
    class << self
      def calculate(message, secret)
        digest = OpenSSL::Digest::Digest.new('sha256')
        Base64.encode64(OpenSSL::HMAC.digest(digest, secret, message)).strip
      end
    end
  end
end
