require 'sinatra/json'
require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/jstpages'
require 'sinatra/backbone'
require 'rubygems'
require 'warden'
require 'sinatra'
require 'cgi'

require "#{::File.expand_path(::File.dirname(__FILE__))}/calendar"
require "#{::File.expand_path(::File.dirname(__FILE__))}/login_manager"
require "#{::File.expand_path(::File.dirname(__FILE__))}/app"

routes = {
  '/'             => App,
  '/warden'       => LoginManager,
  '/calendar'     => Calendar
}

run Rack::URLMap.new routes
