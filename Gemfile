source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in disqualified.gemspec.
gemspec

gem "rails", "~> 7.2"

gem "sqlite3"

gem "sprockets-rails"

gem "mocha", "~> 2.0"

gem "sorbet", group: :development
gem "sorbet-runtime"
gem "tapioca", require: false, group: :development
gem "spoom", require: false, group: :development

gem "standard", "~> 1.0", require: false
gem "rubocop", require: false
gem "rubocop-no_sorbet", require: false, github: "zachahn/rubocop-no_sorbet"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"
