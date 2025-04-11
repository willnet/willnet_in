require 'lamby'
require_relative 'app'

Lamby.config.rack_app = ::Rack::Builder.new { run ::App }.to_app
