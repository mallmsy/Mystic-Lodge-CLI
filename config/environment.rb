require 'bundler'
Bundler.require
require 'json'
require 'open-uri'
require 'date'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = Logger.new(nil)

require_all 'lib'
# require_relative '../db/seeds'
