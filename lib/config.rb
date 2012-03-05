require 'rubygems'
require "bundler/setup"
require 'mongo'
require 'mongoid'
require 'mongo'
#require 'em-synchrony'
#require 'em-synchrony/mongo'
#require 'em-synchrony/em-mongo'
require 'eventmachine'
require 'yajl'
#require 'pp'
#require 'set'
#require 'mail'
#require 'digest/sha2'
#require 'digest/md5'
#require 'nokogiri'


mongoid_conn = Mongo::Connection.new 'localhost', 27017, :pool_size => 10
Mongoid.configure do |c|
  c.max_retries_on_connection_failure = 0
  # c.skip_version_check = true
  c.identity_map_enabled = false

  begin
    db_name = 'bidder_01'

    if ENV['RACK_ENV']  && ENV['RACK_ENV'] == 'test'
      db_name = 'bidder_test'
    end
    c.master = mongoid_conn.db(db_name)

  rescue Exception=>err
    abort "An error occurred while creating the mongoid connection pool: #{err}"
  end
end

# load all models
Dir.glob(File.expand_path(File.dirname(__FILE__)) + '/models/*.rb') {|file| require file}
