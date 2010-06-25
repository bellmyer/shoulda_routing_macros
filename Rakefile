require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the shoulda_routing_macros plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the shoulda_routing_macros plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ShouldaRoutingMacros'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "shoulda_routing_macros"
    gemspec.summary = "easy shoulda testing of restful routes"
    gemspec.description = "Routes are an important part of your application.  The larger the app, the more valuable test-driven routing will be.  This gem makes testing routes as easy as defining them."
    gemspec.email = "ruby@kconrails.com"
    gemspec.homepage = "http://github.com/bellmyer/shoulda_routing_macros"
    gemspec.authors = ["Jaime Bellmyer"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
