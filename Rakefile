# Bundler

require 'bundler'
Bundler::GemHelper.install_tasks


# RSpec2
require 'rspec/core/rake_task'

desc "Run the specs under spec"
RSpec::Core::RakeTask.new do |t|
end


# Jeweler

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "range_validator"
    gem.homepage = "http://github.com/chrisb87/range_validator"
    gem.license = "MIT"
    gem.summary = "Active Model Range Validator"
    gem.description = %Q{Active Model Range Validator. 
      Supports validating that active model fields are valid ranges that do or do
      not overlap with other ranges.}
    gem.email = "baker.chris.3@gmail.com"
    gem.authors = ["Chris Baker"]
    
    gem.add_dependency("activemodel", ">= 3.0.0")
    gem.add_dependency("activesupport", ">= 3.0.0")

    gem.add_development_dependency "rspec", ">= 2.5.0"
    gem.add_development_dependency "ruby-debug"
  end
  Jeweler::RubygemsDotOrgTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
