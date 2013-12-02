require 'httparty'
require './gemnasium'

g = HTTParty.get('https://raw.github.com/khash/stacks-test/master/Gemfile').parsed_response
gl = HTTParty.get('https://raw.github.com/khash/stacks-test/master/Gemfile.lock').parsed_response

puts "Gemfile"
puts g
puts "Gemfile.lock"
puts gl

p = Gemnasium.evaluate(g, gl)

puts p
