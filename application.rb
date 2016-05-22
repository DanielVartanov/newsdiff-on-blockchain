require 'digest'
require 'http'
require 'nokogiri'
require 'active_record'

Dir[File.expand_path "app/**/*.rb"].each { |file| require_relative(file) }

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection YAML::load(File.open('db/config.yml'))['development']
