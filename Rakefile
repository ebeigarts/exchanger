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

task :default => [:prepare_config, :spec]

task :prepare_config do
  unless File.exists? "spec/config.yml"
    cp "spec/config.yml.example", "spec/config.yml"
  end
  unless File.exists? "spec/fixtures/get_user_availability.yml"
    cp "spec/fixtures/get_user_availability.yml.example", "spec/fixtures/get_user_availability.yml"
  end
end
