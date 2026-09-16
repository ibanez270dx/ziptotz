# frozen_string_literal: true

require_relative "lib/zip_to_tz/version"

Gem::Specification.new do |spec|
  spec.name = "zip_to_tz"
  spec.version = ZipToTz::VERSION
  spec.license = "MIT"
  spec.summary = "Convert US zip codes into timezones."
  spec.description = "A Ruby port of the zipToTz Node.js library. Looks up the IANA timezone name or abbreviation for a US zip code."
  spec.authors = ["Jeff Miller"]
  spec.email = ["jeff@humani.se"]
  spec.homepage = "https://github.com/ibanez270dx/ziptotz"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .rspec spec/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
