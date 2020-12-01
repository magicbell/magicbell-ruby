describe MagicBell do
  let(:api_secret) { "dummy_api_secret" }

  describe ".configure" do
    let(:magic_address) { "dummy_magic_address@ring.magicbell.io" }
    let(:api_key) { "dummy_api_key" }
    let(:project_id) { 1 }

    before do
      MagicBell.configure do |config|
        config.magic_address = magic_address
        config.api_key = api_key
        config.api_secret = api_secret
        config.project_id = project_id
      end
    end

    after do
      MagicBell.reset_config
    end

    it "configures the gem" do
      expect(MagicBell.magic_address).to eq(magic_address)
      expect(MagicBell.api_key).to eq(api_key)
      expect(MagicBell.api_secret).to eq(api_secret)
      expect(MagicBell.api_secret).to eq(api_secret)
      expect(MagicBell.api_host).to eq("https://api.example.com")
    end
  end

  def base64_decode(base64_decoded_string)
    Base64.decode64(base64_decoded_string)
  end

  describe "#hmac" do
    let(:api_secret) { "dummy_api_secret" }
    let(:user_email) { "john@example.com" }
    it "calculates the hmac for the given string" do
      api_secret = "dummy_api_secret"
      user_email = "john@example.com"

      ENV["MAGICBELL_API_SECRET"] = "dummy_api_secret"

      hmac = MagicBell.hmac(user_email)
      # expect(MagicBell.hmac(user_email)).to eq("6rsCIEh9sNFbxMO4NQfBMG88eXWMufPPUubCTggCfnE=")
      sha256_digest = OpenSSL::Digest.new('sha256')
      expect(base64_decode(hmac)).to eq(OpenSSL::HMAC.digest(sha256_digest, api_secret, user_email))
    end
  end
end
