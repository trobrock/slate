# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slate/version'

Gem::Specification.new do |gem|
  gem.name          = "slate"
  gem.version       = Slate::VERSION
  gem.authors       = ["Trae Robrock"]
  gem.email         = ["trobrock@gmail.com"]
  gem.description   = %q{Simple api on top of the graphite render api}
  gem.summary       = %q{Simple wrapper on top of the graphite render api}
  gem.homepage      = "https://github.com/trobrock/slate"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "faraday", "~> 0.8"
  gem.add_dependency "json", "~> 1.7"
  gem.add_dependency "jruby-openssl" if RUBY_PLATFORM == 'java'
  gem.add_dependency "treetop", "~> 1.4"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rb-fsevent", "~> 0.9"
  gem.add_development_dependency "coveralls", "~> 0.6.3"
end
