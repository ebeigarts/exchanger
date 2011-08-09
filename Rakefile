require "rubygems"
require "bundler"
Bundler.setup
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
require "yard"

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb', 'README.md']
end

task :default => :spec
