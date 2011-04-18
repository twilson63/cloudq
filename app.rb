$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'bundler/setup'
require 'json'
require 'sinatra'
require 'em-redis'
require 'sinatra/async'
require 'uuidtools'
require 'uri'
require 'rack/params'



class Cloudq < Sinatra::Base
  register Sinatra::Async

  use Rack::Params

  def redis
    @redis ||= (
      uri = URI(ENV['REDISTOGO_URL'] || 'redis://127.0.0.1/')
      EM::Protocols::Redis.connect(:host => uri.host, :port => uri.port, :password => uri.password)
    )
  end

  aget '/' do
    body "Welcome to Cloudq"
  end

  # Post Job to the Queue
  apost "/:queue" do |q|
    redis.push_head queue(q), env['params']['job'].to_json do
      result = { :status => "success" }.to_json
      body result
    end
  end


  # Get Job from the Queue
  aget "/:queue" do |q|
    redis.pop_tail(queue(q)) do |response|
      if response 
        id = UUIDTools::UUID.random_create.to_s 
        job = JSON.parse(response).merge(:id => id)
        redis.set id, job
        body job.to_json
      else
        result = { :status => :empty }.to_json
        body result
      end
    end
  end

  # Remove Job from the Queue

  adelete "/:queue/:id" do |q, id|
    redis.delete id do
      result = { :status => :success }.to_json
      body result
    end
  end

  def queue(name)
    [name,'-',:queued].join('')
  end
end

