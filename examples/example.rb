require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/som_data')
require File.expand_path(File.dirname(__FILE__) + '/../lib/som')

data = SOM_DATA

a = SOM.new(data, :nodes => 8, :dimensions => 4)

a.train

# Returns the index of the data you gave it
puts a.inspect.inspect