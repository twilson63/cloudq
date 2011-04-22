require 'spec_helper'
require 'rest-client'

describe 'publish job' do
  it 'publishes job from json' do
    json_data = '{"job": {"klass": "Archive", "args": [{"hello": "world"}]}}'
    headers = { :content_type => "application/json", :accept => "application/json" }
    RestClient.post "http://localhost:3000/myqueue", json_data, headers
  end



end
