$:.push File.expand_path("../lib", __FILE__)

require "dynamic_query/version"

Gem::Specification.new do |s|
  s.name = "dynamic_query"
  s.version = DynamicQuery::VERSION
  s.authors = ["Wei-Ming Wu"]
  s.date = "2013-03-05"
  s.description = "A dynamic query gui for ActiveRecord"
  s.email = "wnameless@gmail.com"
  
  s.files = Dir["{lib,app}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  s.homepage = "http://github.com/wnameless/dynamic_query"
  s.licenses = ["Apache License, Version 2.0"]
  s.require_paths = ["lib"]
  s.summary = "dynamic_query-#{DynamicQuery::VERSION}"

  s.add_runtime_dependency "rails", "~> 3.2.0"
  s.add_runtime_dependency "jquery-rails", "~> 2.2.0"
  
  s.add_development_dependency "sqlite3", "~> 1.3.7"
  s.add_development_dependency "shoulda", "~> 3.3.2"
  s.add_development_dependency "rdoc", "~> 3.12"
  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
end

