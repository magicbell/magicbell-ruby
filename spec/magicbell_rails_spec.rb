describe MagicBellRails do
  let(:api_secret) { "dummy_api_secret" }

  describe ".configure" do
    let(:magic_address) { "dummy_magic_address@ring.magicbell.io" }
    let(:api_key) { "dummy_api_key" }
    let(:project_id) { 1 }

    before do
      MagicBellRails.configure do |config|
        config.magic_address = magic_address
        config.api_key = api_key
        config.api_secret = api_secret
        config.project_id = project_id
      end
    end

    after do
      MagicBellRails.reset_config
    end

    it "configures the gem" do
      expect(MagicBellRails.magic_address).to eq(magic_address)
      expect(MagicBellRails.api_key).to eq(api_key)
      expect(MagicBellRails.api_secret).to eq(api_secret)
      expect(MagicBellRails.api_secret).to eq(api_secret)
    end
  end

  describe ".host_page_css_url" do
    it "returns the url to fetch magicbell widget's css from" do
      expect(MagicBellRails.host_page_css_url).to eq("//app.magicbell.io/assets/magicbell.css")
    end
  end

  describe ".widget_javascript_url" do
    it "returns the url to fetch magicbell widget's javascript from" do
      expect(MagicBellRails.widget_javascript_url).to eq("//dxd8ma9fvw6e2.cloudfront.net/widget.magicbell.js")
    end
  end

  describe ".user_key" do
    let(:user_email) { "user@example.com" }

    before do
      MagicBellRails.configure do |config|
        config.api_secret = api_secret
      end
    end

    after do
      MagicBellRails.reset_config
    end

    it "calculates the user key for the given user's email" do
      expect(MagicBellRails.user_key(user_email)).to eq(MagicBellRails::HMAC.calculate(user_email, api_secret))
    end
  end
end