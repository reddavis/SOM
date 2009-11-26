require File.expand_path(File.dirname(__FILE__) + '/../lib/som')

data = Array.new(100) {Array.new(3) {rand}}

a = SOM.new(:number_of_nodes => 4, :dimensions => 3)

a.train(data)

# Returns the index of the data you gave it
puts a.inspect.inspect