$:.unshift(File.join(File.dirname(__FILE__), '..','lib'))

require 'cloudq'
#require 'rack/test'

set :environment, :test

RSpec.configure do
#  include Rack::Test::Methods

end




