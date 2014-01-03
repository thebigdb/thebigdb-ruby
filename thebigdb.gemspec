$:.push File.expand_path("../lib", __FILE__)
require "thebigdb/version"

Gem::Specification.new do |s|
  s.name = "thebigdb"
  s.version = TheBigDB::VERSION::STRING
  s.summary = "Ruby bindings for TheBigDB API"
  s.description = "TheBigDB a simply structured open database of real life facts. See http://thebigdb.com for details."
  s.authors = ["Christophe Maximin"]
  s.email = "christophe@thebigdb.com"
  s.homepage = "http://thebigdb.com"

  s.platform = Gem::Platform::RUBY

  s.add_runtime_dependency "rack", "~> 1.4"

  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 2.12"
  s.add_development_dependency "guard-rspec", "~> 2.3"
  s.add_development_dependency "rb-inotify", "~> 0"
  s.add_development_dependency "rb-fsevent", "~> 0"
  s.add_development_dependency "rb-fchange", "~> 0"
  s.add_development_dependency "webmock", "~> 1.9"



  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]
end
