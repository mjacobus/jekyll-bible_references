# frozen_string_literal: true

require_relative "lib/jekyll/bible_references/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-bible_references"
  spec.version = Jekyll::BibleReferences::VERSION
  spec.authors = ["Marcelo Jacobus"]
  spec.email = ["marcelo.jacobus@gmail.com"]

  spec.summary = "A plugin for Jekyll to generate Bible references"
  spec.description = "A plugin for Jekyll to generate Bible references"
  spec.homepage = "https://github.com/mjacobus/jekyl-bible_references"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "html-pipeline", "~> 2.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
