$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "delete_you_later/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "delete_you_later"
  spec.version     = DeleteYouLater::VERSION
  spec.authors     = ["Josh Brody"]
  spec.email       = ["josh@josh.mn"]
  spec.homepage    = ""
  spec.summary     = "Summary of DeleteYouLater."
  spec.description = "Description of DeleteYouLater."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']
  spec.files += Dir['lib/**/*.rb']

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "railties", ">= 5"
  spec.add_dependency "activerecord", ">= 5"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'pry', '~> 0.11.3'
  spec.add_development_dependency 'rails', '>= 3.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
