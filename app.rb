require 'bundler/setup'
require 'json'
require 'sinatra'
require 'em-redis'
require 'sinatra/async'
require 'uuidtools'


class Cloudq < Sinatra::Base
  register Sinatra::Async

  aget '/' do
    body "Welcome to Cloudq"
  end

  # Post Job to the Queue
  apost "/:queue" do |q|
    # parse data from json
    data = request.body.read.to_s
    params['job'] = JSON.parse(data)['job']
    
    # push into redis
    redis = EM::Protocols::Redis.connect(ENV['REDISTOGO_URL'])
    redis.push_head [q,'-',:queued].join(''), params['job'].to_json

    body "Success"
  end


  # Get Job from the Queue
  aget "/:queue" do |q|
    redis = EM::Protocols::Redis.connect(ENV['REDISTOGO_URL'])
    redis.rpop [q,'-',:queued].join('') do |response|
      if response 
        id = UUIDTools::UUID.random_create.to_s 
        job = JSON.parse(response).merge(:id => id)
        redis.set id, job
        body job.to_json
      else
        body "empty"
      end
    end
  end

  # Remove Job from the Queue

  adelete "/:queue/:id" do |q, id|
    redis = EM::Protocols::Redis.connect(ENV['REDISTOGO_URL'])
    redis.delete id
    body "Success"
  end
end

