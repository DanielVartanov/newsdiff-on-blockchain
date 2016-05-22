require 'digest'
require 'http'
require 'nokogiri'
require 'active_record'

require_relative 'app/news'
require_relative 'app/snapshot'
require_relative 'app/news_data'
require_relative 'app/agencies/agency'
require_relative 'app/agencies/knews'

environment = ENV['ENVIRONMENT'] || 'development'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection YAML::load(File.open('db/config.yml'))[environment]
