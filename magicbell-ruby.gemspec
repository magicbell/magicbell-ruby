$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "magicbell/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "magicbell"
  s.version       = MagicBell::VERSION
  s.authors       = ["Hana Mohan", "Nisanth Chunduru"]
  s.email         = ["hana@magicbell.io", "nisanth@supportbee.com"]
  s.homepage      = "https://magicbell.io"
  s.summary       = "Ruby wrapper for MagicBell.io"
  s.description   = "Notifications like never before!"
  s.license       = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'httparty'
  s.add_dependency 'activesupport'

  s.add_development_dependency "actionmailer"
  s.add_development_dependency "rspec", '~> 3.9'
  s.add_development_dependency "webmock"
  s.add_development_dependency "pry"
  s.add_development_dependency "rake"
end
