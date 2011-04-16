$:.unshift(File.join(File.dirname(__FILE__), '..'))

require 'app'
require 'sinatra/async/test'
require 'test/unit'
require 'rack/test'

RSpec.configure do
  include Rack::Test::Methods
  include Sinatra::Async::Test::Methods
  include Test::Unit::Assertions

end

def app
  Cloudq
end



