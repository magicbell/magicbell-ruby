describe MagicBellRails::User do
    it "should be not throw an error on init" do
      user = MagicBellRails::User.new(email: 'hana@magicbell.io')
      expect(user.email).to eq 'hana@magicbell.io'
    end
end