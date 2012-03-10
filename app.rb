require "#{File.expand_path(File.dirname(__FILE__))}/lib/config.rb"
require 'sinatra'
require "sinatra/reloader"
require 'sinatra/json'
require 'sinatra/base'
require 'sinatra/jstpages'
require 'sinatra/backbone'
require 'faye'

class App < Sinatra::Base
  register Sinatra::JstPages
  serve_jst '/jst.js'

  register Sinatra::Reloader
  helpers Sinatra::JSON


    get '/' do
      erb :"index"
    end
end
