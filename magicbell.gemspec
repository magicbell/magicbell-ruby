# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'magicbell/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = 'magicbell'
  s.version       = MagicBell::VERSION
  s.authors       = ['Hana Mohan', 'Nisanth Chunduru', 'Rahmane Ousmane', 'Josue Montano']
  s.email         = ['hana@magicbell.io', 'nisanth@supportbee.com', 'rahmane@magicbell.io', 'josue@magicbell.io']
  s.homepage      = 'https://magicbell.com'
  s.summary       = 'Ruby Library for MagicBell'
  s.description   = 'The notification inbox for your product'
  s.license       = 'MIT'

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'activesupport'
  s.add_dependency 'httparty'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.9'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'webmock'

  s.post_install_message = '
    *** Breaking Change:: The 3.0.0 release removes the actionmailer functionality. ***
  '
end
