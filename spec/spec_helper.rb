$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'springlayout_dsl'
require 'rspec/core'

RSpec::Core::Runner.autorun do |config|
  
end
