# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/dynamic_query/version.rb'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "dynamic_query"
  gem.homepage = "http://github.com/wnameless/dynamic_query"
  gem.license = "Apache License, Version 2.0"
  gem.version = DynamicQuery::Version::STRING
  gem.summary = "dynamic_query-#{gem.version}"
  gem.description = %Q{A dynamic query gui for ActiveRecord}
  gem.email = "wnameless@gmail.com"
  gem.authors = ["Wei-Ming Wu"]
  # dependencies defined in Gemfile
  gem.files = Dir["{app,lib}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dynamic_query #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
