# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano-redmine/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Aleksey Kurepin"]
  gem.email         = ["lesha@kurepin.com"]
  gem.description   = %q{This gem contains a Capistrano :task, which allows to
    update the Redmine issues statuses when you do deploy with Capistrano.}
  gem.summary       = %q{Update Redmine issues statuses on Capistrano deploy.}
  gem.homepage      = "http://github.com/foxweb/capistrano-redmine"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "capistrano-redmine"
  gem.require_paths = ["lib"]
  gem.version       = Capistrano::Redmine::VERSION
end
