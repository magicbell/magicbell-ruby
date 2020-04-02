source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec path: ".."

gem "rails", "~> 5.1.0"
