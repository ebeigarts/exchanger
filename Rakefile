require "rubygems"
require "bundler"
Bundler.setup

require "spec/rake/spectask"
require "yard"

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob("spec/**/*_spec.rb")
  t.spec_opts << "--format specdoc"
  t.rcov = true
  t.rcov_opts << "--exclude osx\/objc,gems\/,spec\/,features\/,\/Library\/"
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb', 'README.md']
end

task :default => :spec
