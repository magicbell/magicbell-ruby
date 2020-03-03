module MagicBellRails
  class User

    attr_accessor :email
    
    def initialize(attributes)
      @attributes = attributes
      @email = @attributes[:email]
    end
  end
end