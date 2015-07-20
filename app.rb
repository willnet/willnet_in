require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

class App < Sinatra::Base
  get '/' do
    haml :index
  end
end
