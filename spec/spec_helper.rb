$:.unshift File.dirname(__FILE__) + '/../lib'

require "rubygems"
require "exchanger"
require "kconv"

Exchanger::Config.instance.from_hash(YAML.load_file("#{File.dirname(__FILE__)}/config.yml"))
