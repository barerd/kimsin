# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kimsin/version"

Gem::Specification.new do |gem|
  gem.name		= "kimsin"
  gem.version		= NAME::VERSION
  gem.authors		= ["Basar Erdivanli"]
  gem.email		= ["berdivanli@gmail.com"]
  gem.homepage		= "" 
  gem.summary		= %q{A simple logging app}
  gem.description	= %q{A simple logging app using the powerful bcrypt gem and sinatra web framework}

  gem.rubyforge_project	= "kimsin"

  gem.files		= 'git ls-files'.split("\n")
  gem.test_files	= 'git ls-files -- {test,spec,features}/*'.split("\n")
  gem.executables	= 'git ls-files -- bin/*'.split("\n").map{|f| File.basename(f)}
  gem.require_paths	= ["lib"]

  gem.add_dependency	= "bcrypt-ruby"
  gem.add_dependency	= "rack"
  gem.add_dependency	= "sinatra"
  gem.add_dependency	= "thin"
end
