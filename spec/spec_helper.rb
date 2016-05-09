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
  c.filter_sensitive_data('FILTERED_USERNAME') { CGI::escape(Exchanger.config.username) }  # Filter escaped version from request > uri
  c.filter_sensitive_data('FILTERED_EMAIL_ADDRESS') { Exchanger.config.username }          # Filter unescaped version from request > body > string
  c.filter_sensitive_data('FILTERED_PASSWORD') { CGI::escape(Exchanger.config.password) }

  # Record an endpoint that matches the Travis CI configuration to ensure that the cassette files are used when CI tests run
  ci_endpoint = YAML.load_file("#{File.dirname(__FILE__)}/config.yml.example")["endpoint"]
  ci_endpoint = URI.parse(ci_endpoint).host
  dev_endpoint = URI.parse(Exchanger.config.endpoint).host
  c.filter_sensitive_data(ci_endpoint) { dev_endpoint }
end
