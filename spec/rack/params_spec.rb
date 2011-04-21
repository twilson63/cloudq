require 'spec_helper'

describe Rack::Params do
  subject do 
    Rack::Params.new({})
  end

  it 'should convert json to params' do
    env = {
      'rack.input' => StringIO.new(%Q{{"job":{"klass": "Archive"}}}),
      'CONTENT_TYPE' => 'application/json'
    }
    
    puts subject.retrieve_params(env)
    #puts env['params']
  end
end
