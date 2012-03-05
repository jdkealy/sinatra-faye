require "#{File.expand_path(File.dirname(__FILE__))}/lib/config.rb"
require 'sinatra'
require "sinatra/reloader"
require 'sinatra/json'
require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/jstpages'
require 'sinatra/backbone'
class Calendar < Sinatra::Base
  register Sinatra::JstPages
  serve_jst '/jst.js'

  register Sinatra::Reloader
  helpers Sinatra::JSON

    get '/dates/?' do
      month_number = params['month'].to_i

      first_of_month  = (Date.today +   month_number.month).at_beginning_of_month
      first_of_month  = first_of_month - first_of_month.wday

      last_of_month   = first_of_month + 1.month - 1.day
      last_of_month   = last_of_month  + (6-last_of_month.wday)

      json_array = (first_of_month..last_of_month)

      dates = {}
      date_array = Array.new

      x = 0
      json_array.each do |day|
        date = {}
        date[:date] = day
        date_array <<  date
      end
      json date_array
    end
end
