$:.unshift File.dirname(__FILE__) + '/lib'

require "rubygems"
require "exchanger"

Exchanger::Config.instance.from_hash(YAML.load_file("#{File.dirname(__FILE__)}/spec/config.yml"))
