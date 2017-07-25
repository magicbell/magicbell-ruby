Gem::Specification.new do |s|
  s.name          = "magicbell-rails"
  s.summary       = "Makes it easy to add magicbell.io widget to your rails app"
  s.version       = "1.1"
  s.date          = "2016-07-13"
  s.authors       = ["Hana Mohan", "Nisanth Chunduru"]
  s.email         = ["hana@magicbell.io", "nisanth@magicbell.io"]
  s.files         = Dir["{lib}/**/*"] + ["README.md"]

  s.add_dependency("activesupport")
  s.add_dependency("json")
  s.add_dependency("rails")

  s.add_development_dependency("rspec", "~> 3.0")
  s.add_development_dependency("pry")
end
