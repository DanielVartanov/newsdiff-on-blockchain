require 'digest'
require 'http'
require 'nokogiri'
require 'active_record'
require 'erb'

require_relative 'app/news'
require_relative 'app/snapshot'
require_relative 'app/news_data'
require_relative 'app/agencies/agency'

require_relative 'app/agencies/khabar'
require_relative 'app/agencies/azattyq'

require_relative 'app/agencies/knews'
require_relative 'app/agencies/azattyk'
require_relative 'app/agencies/kabar'
require_relative 'app/agencies/kg24'
require_relative 'app/agencies/kloop'
require_relative 'app/agencies/kyrtag'
require_relative 'app/agencies/tazabek'
require_relative 'app/agencies/vb'
require_relative 'app/agencies/zanoza'
require_relative 'app/agencies/sputnik'

environment = ENV['ENVIRONMENT'] || 'development'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger.level = (environment == 'development') ? Logger::DEBUG : Logger::INFO

ROOT_DIRECTORY = __dir__

ActiveRecord::Base.establish_connection YAML::load(ERB.new(File.read(File.join(ROOT_DIRECTORY, 'db/config.yml'))).result)[environment]
