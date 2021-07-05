describe MagicBell do
  let(:api_key) { "dummy_api_key" }
  let(:api_secret) { "dummy_api_secret" }

  before do
    MagicBell.configure do |config|
      config.api_key = api_key
      config.api_secret = api_secret
    end
  end

  after do
    MagicBell.reset_config
  end

  describe ".configure" do
    it "configures the gem" do
      expect(MagicBell.api_key).to eq(api_key)
      expect(MagicBell.api_secret).to eq(api_secret)
      expect(MagicBell.api_secret).to eq(api_secret)
    end
  end

  def base64_decode(base64_decoded_string)
    Base64.decode64(base64_decoded_string)
  end

  describe "#hmac" do
    let(:user_email) { "john@example.com" }
    let(:magicbell) { MagicBell::Client.new }

    it "calls the hmac method on MagicBell::Client object" do
      expect(MagicBell::Client).to receive(:new).with(api_key: MagicBell.api_key, api_secret: MagicBell.api_secret).and_return(magicbell)
      expect(magicbell).to receive(:hmac).with(user_email)

      MagicBell.hmac(user_email)
    end
  end
end
