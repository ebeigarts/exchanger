# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "exchanger/version"

Gem::Specification.new do |s|
  s.name        = "exchanger"
  s.version     = Exchanger::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Edgars Beigarts"]
  s.email       = "edgars.beigarts@gmail.com"
  s.homepage    = "http://github.com/ebeigarts/exchanger"
  s.description = %q{Ruby library for accessing Microsoft Exchange using Exchange Web Services}
  s.summary     = s.description

  s.rubygems_version = "1.3.6"

  s.add_runtime_dependency "activesupport", [">= 2.2.2"]
  s.add_runtime_dependency "nokogiri", [">= 1.3.0"]
  s.add_runtime_dependency "httpclient", [">= 2.1.5.2"]
  s.add_runtime_dependency "rubyntlm", [">= 0.1.1"]
  s.add_runtime_dependency "tzinfo", [">= 0.3.33"]

  s.add_development_dependency "rake"
  s.add_development_dependency "i18n" # required by activesupport
  s.add_development_dependency "rspec", ["~> 2.6.0"]
  s.add_development_dependency "simplecov"
  s.add_development_dependency "yard"
  s.add_development_dependency "BlueCloth" # required by yard
  s.add_development_dependency "vcr", ["~> 2.2.5"]
  s.add_development_dependency "webmock", ["~> 1.8.11"]

  s.files          = Dir.glob("{lib,spec}/**/*") + %w(README.md LICENSE)
  s.require_paths  = ["lib"]
end
