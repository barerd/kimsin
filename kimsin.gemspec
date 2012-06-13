# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kimsin/version"

Gem::Specification.new do |gem|
  gem.name        = "kimsin"
  gem.version     = Kimsin::VERSION
  gem.authors     = ["Basar Erdivanli"]
  gem.email       = ["berdivanli@gmail.com"]
  gem.homepage    = "" 
  gem.summary     = %q{A simple logging app}
  gem.description = %q{A simple logging app using the powerful bcrypt gem and sinatra web framework}

  gem.rubyforge_project	= "kimsin"

  gem.files         = 'git ls-files'.split("\n")
  gem.test_files    = 'git ls-files -- {test,spec,features}/*'.split("\n")
  gem.executables   = 'git ls-files -- bin/*'.split("\n").map{|f| File.basename(f)}
  gem.require_paths = ["lib"]

  gem.add_dependency	= "bcrypt-ruby", ">= 3.0.1"
  gem.add_dependency	= "rack", ">= 1.4.1"
  gem.add_dependency	= "sinatra", :require => "sinatra/base"
  gem.add_dependency	= "thin", ">= 1.3.1"
  gem.add_dependency	= "i18n", ">= 0.6.0"
  gem.add_dependency	= "datamapper", ">= 1.2.0"
  gem.add_dependency	= "sqlite3", ">= 1.3.6"
end
