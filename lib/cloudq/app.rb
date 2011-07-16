module Cloudq
  class App < Sinatra::Base
    register Sinatra::Async

    use Rack::Params

    def self.version
      "0.0.8"
    end

    aget '/' do
      body "Welcome to Cloudq Framework"
    end
    
    aget '/mu-8a96bb28-3144ff61-26ebfcaf-2d0f9b36' do
      '42'
    end

    # Post Job to the Queue
    apost "/:queue" do |q|
      # Rack::Params set env['params'] not params
      halt 500 if env["params"]["job"].nil?
      Job.create(env["params"]["job"].merge(:queue => q))
      status = { :status => "success" }.to_json
      body status
    end


    # Get Job from the Queue
    aget "/:queue" do |q|
      job = Job.where(:queue => q.to_sym, :workflow_state => :queued).first
      if job
        job.reserve!
        body job.to_json
      else
        status = { :status => :empty }.to_json
        body status
      end
    end

    # Remove Job from the Queue
    adelete "/:queue/:id" do |q, id|
      job = Job.where(:queue => q.to_sym, :id => id).first
      halt 404 unless job
      job.delete!
      status = { :status => "success" }.to_json
      body status
    end

  end
end
