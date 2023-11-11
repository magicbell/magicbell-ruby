# frozen_string_literal: true

module MagicBell
  class SingletonApiResource < ApiResource
    def create_path
      path
    end
  end
end
