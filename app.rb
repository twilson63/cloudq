$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'bundler/setup'
require 'json'
require 'sinatra'
require 'sinatra/async'
require 'workflow'
require 'job'
require 'rack/params'

if ENV['MONGOHQ_URL']
  MongoMapper.config = {:production => {'uri' => ENV['MONGOHQ_URL']}}
  MongoMapper.connect(:production)
else
  MongoMapper.database = 'cloudq'
end


class Cloudq < Sinatra::Base
  register Sinatra::Async

  use Rack::Params

  aget '/' do
    body "Welcome to Cloudq"
  end

  # Post Job to the Queue
  apost "/:queue" do |q|
    halt 500 if params["job"].nil?
    Job.create(params["job"].merge(:queue => q))
    body { :status => "success" }.to_json
  end


  # Get Job from the Queue
  aget "/:queue" do |q|
    job = Job.where(:queue => q.to_sym, :workflow_state => :queued).first
    if job
      job.reserve!
      body job.to_json
    else
      body { :status => :empty }.to_json
    end
  end

  # Remove Job from the Queue

  adelete "/:queue/:id" do |q, id|
    job = Job.where(:queue => q.to_sym, :id => id).first
    halt 404 unless job
    job.delete!
    body { :status => "success" }.to_json
  end

end

