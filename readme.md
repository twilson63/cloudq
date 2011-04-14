# CLOUDQ

( Work in Progress....)

## What is this?

This is a high performance restful json web queue system implemented in
ruby.

## Why?

We looked for remote broker queue implementations for ruby and could not
find anything that fit our needs, so we decided to take a stab at it.
Using NoSQL tools like MongoDb and using Async Server tools like Async
Sinatra seem like the perfect fit for this project.  But we designed the
model to be implemented in any technology or data store.

# Requirements

mongodb
async web server (thin, etc)

# Plugins

You can add plugs for authentication and logging and other great stuff
through rack middleware.


# API

The api pattern is like so:

    / [ Queue Name ] / [ Action ] 

    and

    / [ Queue Name ] / [ Action ] / [ id ]


## Add to Queue

    post /myqueue
      klass: 'Archive'
      args: { [ args here ] }

## Reserve Message

    get /myqueue
    
    # JSON =>
    { 
      klass: 'Archive'
      args: {}
      id: 1234
    }

## Delete Message

    delete /myqueue/1234


---

You can create as many queues as you want, when you post your first
message in the queue, it will create that queue, and when you perform
reserver, the worker will pull in a first in, first out process.

---

## Publish Job in Ruby

    gem install cloudq_client

    require 'cloudq_client/publish'

    Cloudq::Connection.url = 'http://donuts.com'
    Cloudq::Publish.job(:make_donuts, 'Donut', :types => [:glazed,
:chocolate])


---

### Worker in Ruby

    gem install cloudq_client

    require 'cloudq_client/cosume'
    require 'Donut'

    Cloudq::Connection.url = 'http://donuts.com'
    loop do
      Cloudq::Consume.job(:make_donuts)
      sleep 5
    end


---

The worker can be implemented in any language, but the api is designed
to return a json message that will call the perform class method and
pass in arguments to that method for processing:

    klass = Object.const_get(payload[:klass].capitalize)
    klass.perform(*payload[:args])



---







