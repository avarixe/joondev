$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cmsk/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cmsk"
  s.version     = Cmsk::VERSION
  s.authors     = ["Joon Lee"]
  s.email       = ["joon.lee@ucla.edu"]
  s.homepage    = ""
  s.summary     = "Career Mode Stat Keeper - engine version."
  s.description = "Engine application to keep track of games played in FIFA Career Mode."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
