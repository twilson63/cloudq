require 'bundler/setup'
require 'json'
require 'sinatra'
require 'mongo_mapper'
require 'workflow'
require 'sinatra/async'

require_relative 'job'

if ENV['MONGOHQ_URL']
  MongoMapper.config = {:production => {'uri' => ENV['MONGOHQ_URL']}}
  MongoMapper.connect(:production)
end



MongoMapper.database = 'cloudq'

class Cloudq < Sinatra::Base
  register Sinatra::Async

  aget '/' do
    body "Welcome to Cloudq"
  end

  # Post Job to the Queue
  apost "/:queue" do |q|
    data = request.body.read.to_s
    params['job'] = JSON.parse(data)['job'] unless params['job']
    halt 500 if params["job"].nil?
    Job.create(params["job"].merge(:queue => q))
    body "Success"
  end


  # Get Job from the Queue
  aget "/:queue" do |q|
    #Job.first.to_json 
    job = Job.where(:queue => q.to_sym, :workflow_state => :queued).first
    if job
      job.reserve!
      body job.to_json
    else
      body "empty"
    end

  end

  # Remove Job from the Queue

  adelete "/:queue/:id" do |q, id|
    job = Job.where(:queue => q.to_sym, :id => id).first
    halt 404 unless job
    job.delete!
    body "Success"
  end
end

