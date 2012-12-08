# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "thebigdb/version"

Gem::Specification.new do |s|
  s.name = "thebigdb"
  s.version = TheBigDB::VERSION::STRING
  s.date = "2012-07-12"
  s.summary = "Ruby bindings for TheBigDB API"
  s.description = "TheBigDB a simply structured open database of real life facts. See http://thebigdb.com for details."
  s.authors = ["Christophe Maximin"]
  s.email = "christophe@thebigdb.com"
  s.homepage = "http://thebigdb.com"

  s.platform = Gem::Platform::RUBY

  s.add_development_dependency "rspec", "~> 2.12"
  s.add_development_dependency "guard-rspec", "~> 2.3"
  s.add_development_dependency "rb-inotify"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "rb-fchange"


  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]
end
