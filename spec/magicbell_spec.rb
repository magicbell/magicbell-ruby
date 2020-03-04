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
        config.api_host = "https://api.example.com"
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

  describe ".extras_css_url" do
    it "returns the url to magicbell's extras css" do
      expect(MagicBell.extras_css_url).to eq("//dxd8ma9fvw6e2.cloudfront.net/extras.magicbell.css")
    end
  end

  describe ".host_page_css_url" do
    it "is an alias to .extras_css_url" do
      expect(MagicBell.extras_css_url).to eq("//dxd8ma9fvw6e2.cloudfront.net/extras.magicbell.css")
    end
  end

  describe ".widget_javascript_url" do
    it "returns the url to fetch magicbell widget's javascript from" do
      expect(MagicBell.widget_javascript_url).to eq("//dxd8ma9fvw6e2.cloudfront.net/widget.magicbell.js")
    end
  end

  describe ".user_key" do
    let(:user_email) { "user@example.com" }

    before do
      MagicBell.configure do |config|
        config.api_secret = api_secret
      end
    end

    after do
      MagicBell.reset_config
    end

    it "calculates the user key for the given user's email" do
      expect(MagicBell.user_key(user_email)).to eq(MagicBell::HMAC.calculate(user_email, api_secret))
    end
  end
end