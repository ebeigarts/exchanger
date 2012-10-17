$:.unshift File.dirname(__FILE__) + '/../lib'

require "bundler/setup"
require "simplecov"

SimpleCov.start do
  add_filter '/spec/'
end

require "exchanger"
require "kconv"
require "vcr"
require "webmock"

Exchanger::Config.instance.from_hash(YAML.load_file("#{File.dirname(__FILE__)}/config.yml"))

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.default_cassette_options = { :record => :new_episodes }
  c.filter_sensitive_data('FILTERED_USERNAME') { Exchanger.config.username.gsub("@", "%40") }
  c.filter_sensitive_data('FILTERED_PASSWORD') { Exchanger.config.password }
end
