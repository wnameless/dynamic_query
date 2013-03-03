$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "dynamic_query"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Wei-Ming Wu"]
  s.date = "2013-02-25"
  s.description = "A dynamic query gui for ActiveRecord"
  s.email = "wnameless@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = Dir["{lib,app}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  s.homepage = "http://github.com/wnameless/dynamic_query"
  s.licenses = ["Apache License, Version 2.0"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "dynamic_query-0.5.0"

  s.add_runtime_dependency "rails", "~> 3.2.12"
  s.add_runtime_dependency "jquery-rails", "~> 2.2.0"
  
  s.add_development_dependency "sqlite3", "~> 1.3.7"
  s.add_development_dependency "shoulda", "~> 3.3.2"
  s.add_development_dependency "rdoc", "~> 3.12"
end

