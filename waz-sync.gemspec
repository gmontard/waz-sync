# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name        = 'waz-sync'
  gem.version     = '0.0.3'
  gem.date        = '2012-04-20'
  gem.description = %q{A simple client library aim to sync assets to Windows Azure CDN, using a modified version of the great waz-storage gem}
  gem.summary     = %q{Client library for Syncing assets to Windows Azure CDN}  
  gem.license     = 'MIT'
  gem.authors     = ["Guillaume MONTARD"]
  gem.email       = 'montard@gmail.com'
  gem.files       = `git ls-files`.split($\)  
  gem.homepage    = 'https://github.com/gmontard/waz-sync'
  gem.require_paths = ["lib"]
  gem.rubyforge_project = 'waz-sync'
end