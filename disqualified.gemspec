require_relative "lib/disqualified/version"

Gem::Specification.new do |spec|
  spec.name = "disqualified"
  spec.version = Disqualified::VERSION
  spec.authors = ["Zach Ahn"]
  spec.email = ["engineering@zachahn.com"]
  spec.homepage = "https://github.com/zachahn/disqualified"
  spec.summary = "A background job processor tuned for SQLite"
  spec.license = "LGPL-3.0-only"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zachahn/disqualified"
  spec.metadata["changelog_uri"] = "https://github.com/zachahn/disqualified/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,exe,lib}/**/*", "LICENSE", "README.md"]
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }

  spec.required_ruby_version = ">= 3.1.0"

  spec.add_dependency "rails", ">= 7.0.0"

  spec.add_development_dependency "mocktail"
  spec.add_development_dependency "standard"
end
