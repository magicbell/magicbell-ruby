describe MagicBell::HMAC do
  describe ".calculate" do
    let(:user_email) { "user@example.com" }
    
    it "calculates HMAC for the given message and secret" do
      hmac = MagicBell::HMAC.calculate(user_email)
      expect(hmac).to eq("OHOslhftR8vSJwX5gsLwFylGB5rylNWv/+j+so4+M/c=")
    end
  end
end
