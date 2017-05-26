# -*- encoding: utf-8 -*-

require File.expand_path('../lib/jendle/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "jendle"
  gem.version       = Jendle::VERSION
  gem.summary       = %q{Jenkins as code management tool.}
  gem.description   = %q{Jenkins as code management tool.}
  gem.license       = "MIT"
  gem.authors       = ["toyama0919"]
  gem.email         = "toyama0919@gmail.com"
  gem.homepage      = "https://github.com/toyama0919/jendle"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'thor', '~> 0.19.4'
  gem.add_dependency 'jenkins_api_client'
  gem.add_dependency 'diffy'

  gem.add_development_dependency 'bundler', '~> 1.14.6'
  gem.add_development_dependency 'pry', '~> 0.10.1'
  gem.add_development_dependency 'rake', '~> 10.3.2'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubocop', '~> 0.24.1'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
end
