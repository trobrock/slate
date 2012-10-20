# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphite/version'

Gem::Specification.new do |gem|
  gem.name          = "graphite"
  gem.version       = Graphite::VERSION
  gem.authors       = ["Trae Robrock"]
  gem.email         = ["trobrock@gmail.com"]
  gem.description   = %q{Simple api on top of the graphite render api}
  gem.summary       = %q{Simple wrapper on top of the graphite render api}
  gem.homepage      = "https://github.com/trobrock/graphite_gem"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
end
