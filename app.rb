require 'bundler/setup'
require 'sinatra'
require 'mongo_mapper'
require 'workflow'
require_relative 'job'


MongoMapper.database = 'cloudq'

get '/' do
  "Welcome to Cloudq"
end

# Post Job to the Queue
post "/:queue" do |q|
  halt 500 if params["job"].nil?
  Job.create(params["job"].merge(:queue => q))
end


# Get Job from the Queue
get "/:queue" do |q|
  #Job.first.to_json 
  Job.where(:queue => q.to_sym, :workflow_state => :queued).first.to_json
end

# Remove Job from the Queue

delete "/:queue/:id" do |q, id|
  # should I return a 500 if I can't find the record?
  Job.where(:queue => q.to_sym, :id => id).first.delete
end


