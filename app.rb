require 'rubygems'
require 'bundler/setup'
require 'uri'
require 'time'

Bundler.require(:default)

class App < Sinatra::Base
  get '/' do
    haml :index
  end

  get '/index.atom' do
    redirect to('http://blog.willnet.in/feed')
  end

  get %r{^/([0-9]+)$} do |id|
    Database.start do |db|
      result = db.connection.exec('SELECT * FROM entries WHERE id = $1', [id])
      return 404 if result.nil? || result.none?
      created_at = DateTime.parse(result.first['created_at'])
      redirect "http://blog.willnet.in/entry/#{created_at.strftime('%Y/%m/%d/%H%M%S')}", 301
    end
  end

  error 404 do
    'Not Found'
  end
end

class Database
  attr_reader :connection

  def self.start
    db = new
    yield(db)
  ensure
    db.connection.finish
  end

  def initialize
    fail 'DATABASE_URL is not set' unless ENV['DATABASE_URL']
    uri = URI.parse(ENV['DATABASE_URL'])
    @connection = PG::Connection.new(
      host: uri.host,
      user: uri.user,
      password: uri.password,
      dbname: uri.path[1..-1],
      port: uri.port,
      sslmode: 'require'
    )
  end
end
