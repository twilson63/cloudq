$:.unshift(File.join(File.dirname(__FILE__), '..'))

require 'app'
require 'rack/test'

RSpec.configure do
  include Rack::Test::Methods

end

def app
  Sinatra::Application
end



