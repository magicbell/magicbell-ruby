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
end
