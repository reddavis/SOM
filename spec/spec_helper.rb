$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'som'
require 'spec'
require 'spec/autorun'
require 'rubygems'

Spec::Runner.configure do |config|
  
end
