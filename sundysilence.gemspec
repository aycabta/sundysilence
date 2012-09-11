# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sundysilence/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Code Ass (aycabta)"]
  gem.email         = ["aycabta@gmail.com"]
  gem.description   = "Publish static HTML Wiki that is auto-linked to other pages with page title from Markdown files."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/aycabta/sundysilence"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sundysilence"
  gem.require_paths = ["lib"]
  gem.version       = SundySilence::VERSION
end
