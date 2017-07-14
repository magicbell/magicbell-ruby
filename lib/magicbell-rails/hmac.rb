require "base64"
require "active_support/security_utils"

module MagicBellRails
  module HMAC
    class << self
      def calculate_hmac(message, hmac_key)
        digest  = OpenSSL::Digest::Digest.new('sha256')
        Base64.encode64(OpenSSL::HMAC.digest(digest, hmac_key, message)).strip
      end

      def valid_hmac?(message, hmac_key, hmac)
        ActiveSupport::SecurityUtils.secure_compare(calculate_hmac(message, hmac_key), hmac)
      end
    end
  end
end
