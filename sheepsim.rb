require 'net/http'

puts "Wolfbane sheepsim 2014"

id = "4685"
lat = "63.626745"
long = "11.351395"

uri = URI('http://wolfbane.herokuapp.com/put/')
res = Net::HTTP.post_form(uri, {"id" => "#{id}", "lat" => "#{lat}", "long" => "#{long}"} )
puts res.body
