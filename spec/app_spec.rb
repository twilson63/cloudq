require 'spec_helper'
require 'sinatra/async/test'
require 'test/unit'

describe 'Cloudq Server Application' do
  include Sinatra::Async::Test::Methods
  include Test::Unit::Assertions

  def app
    Cloudq::App
  end

  # list queues
  it 'GET /' do
    aget '/'
    puts last_response.body
  end

  # Post Job to Queue
  # it 'POST /myqueue' do
  #   Job.delete_all
  #   post '/myqueue', {:job => { :klass => 'Archive', :args => {}}}.to_json
  #   last_response.status.should == 200
  #   Job.count.should == 1
  # end

  # # # Reserve Job from Queue
  # it 'GET /myqueue' do
  #   Job.delete_all
  #   Job.create!(:queue => 'myqueue', :klass => 'Archive', :args => {})
  #   get '/myqueue'
  #   last_response.status.should == 200
  #   puts last_response.body
  # end

  # # Remove Job from Queue
  # it 'DELETE /myqueue/1234' do
  #   Job.delete_all
  #   j = Job.create!(:queue => 'myqueue', :klass => 'Archive', :args => {})
  #   delete "/myqueue/#{j.id}"
  #   last_response.status.should == 200
  #   Job.where(:queue => 'myqueue').count == 0
  # end

  # it 'DELETE /myqueue/1234' do
  #   Job.delete_all
  #   j = Job.create!(:queue => 'myqueue', :klass => 'Archive', :args => {})
  #   delete "/myqueue/0"
  #   last_response.status.should == 500

  # end



end

