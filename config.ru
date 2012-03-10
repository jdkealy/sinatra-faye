require 'sinatra/json'
require 'sinatra/base'
require 'sinatra/jstpages'
require 'sinatra/backbone'
require 'rubygems'
require 'sinatra'
require 'cgi'

require "#{::File.expand_path(::File.dirname(__FILE__))}/app"

routes = {
  '/'             => App,
}
require 'faye'
require File.expand_path('../app', __FILE__)

use Faye::RackAdapter, :mount      => '/faye',
                       :timeout    => 25

run Rack::URLMap.new routes
