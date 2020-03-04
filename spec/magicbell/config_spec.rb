describe MagicBell::Config do
  describe "#api_host" do
    it "should default to api.magicbell.io" do
      expect(MagicBell::Config.new.api_host).to eq "https://api.magicbell.io"
    end
  end
end