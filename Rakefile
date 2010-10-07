require "rubygems"
require "spec/rake/spectask"

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob("spec/**/*_spec.rb")
  t.spec_opts << "--format specdoc"
  t.rcov = true
  t.rcov_opts << "--exclude osx\/objc,gems\/,spec\/,features\/,\/Library\/"
end

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name        = "exchanger"
    gem.summary     = "Ruby library for accessing Microsoft Exchange using Exchange Web Services"
    gem.description = gem.summary
    gem.email       = "1@wb4.lv"
    gem.homepage    = "http://github.com/ebeigarts/exchanger"
    gem.authors     = ["Edgars Beigarts"]
  
    gem.add_dependency "activesupport", ">= 2.2.2"
    gem.add_dependency "nokogiri",      ">= 1.3.0"
    gem.add_dependency "httpclient",    ">= 2.1.5.2"
    gem.add_dependency "rubyntlm",      ">= 0.1.1"
  
    gem.add_development_dependency "rspec",    "~> 1.3.0"
  
    gem.files = FileList[
      'lib/**/*.rb',
      'LICENSE',
      'README.md'
    ]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
