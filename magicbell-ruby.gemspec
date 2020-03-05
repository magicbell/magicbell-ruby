Gem::Specification.new do |s|
  s.name          = "magicbell"
  s.summary       = "Ruby wrapper for MagicBell.io"
  s.version       = `cat VERSION`
  s.date          = "2020-03-03"
  s.authors       = ["Hana Mohan", "Nisanth Chunduru"]
  s.email         = ["hana@magicbell.io", "nisanth@supportbee.com"]
  s.files         = Dir["{lib}/**/*"] + ["README.md"]

  s.add_dependency("activesupport")
  s.add_dependency("json")
  s.add_dependency("rails")
  s.add_dependency("faraday")

  s.add_development_dependency("rspec", "~> 3.0")
  s.add_development_dependency("activesupport")
  s.add_development_dependency("pry")
end
