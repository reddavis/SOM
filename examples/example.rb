require File.expand_path(File.dirname(__FILE__) + '/som_data')
require File.expand_path(File.dirname(__FILE__) + '/../lib/som')
require 'benchmark'

require 'rubygems'
require 'normalizer'

#SOM_DATA = Array.new(100) { Array.new(50) {rand}}

min, max = Normalizer.find_min_and_max(SOM_DATA)

normalizer = Normalizer.new(:min => min, :max => max)

data = []

SOM_DATA.each do |n|
  data << normalizer.normalize(n)
end
  
a = SOM.new(data, :nodes => 8)

#puts a.global_distance_error

times = Benchmark.measure do
  a.train
end

#puts a.global_distance_error

#puts a.nodes.inspect

#puts times