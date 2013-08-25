# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git/approvals/version'

Gem::Specification.new do |spec|
  spec.name          = "git-approvals"
  spec.version       = Git::Approvals::VERSION
  spec.authors       = ["Jeremy Ruppel"]
  spec.email         = ["jeremy.ruppel@gmail.com"]
  spec.description   = %q{Simple git-powered approval tests. With RSpec integration.}
  spec.summary       = %q{Simple git-powered approval tests.}
  spec.homepage      = 'https://github.com/jeremyruppel/git-approvals'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'tilt', '~> 1.4.1'

  # soft dependencies
  spec.add_development_dependency 'awesome_print', '~> 1.1.0'
  spec.add_development_dependency 'uglifier',      '~> 2.1.1'
  spec.add_development_dependency 'sass',          '~> 3.2.9'
  spec.add_development_dependency 'nokogiri',      '~> 1.6.0'

  spec.add_development_dependency 'bundler',     '~> 1.3'
  spec.add_development_dependency 'rspec',       '~> 2.13.0'
  spec.add_development_dependency 'guard-rspec', '~> 2.5.2'
  spec.add_development_dependency 'rb-fsevent',  '~> 0.9'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
end
