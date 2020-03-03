describe MagicBellRails::Config do
  describe "#api_host" do
    it "should default to api.magicbell.io" do
      expect(MagicBellRails::Config.new.api_host).to eq "https://api.magicbell.io"
    end
  end
end