# INSERT PROJECT NAME HERE - Maybe CLOUDQ


This is a high performance restful json web queue system.

You can add plugins using rack middleware.

# Requirements

redis
async web server (thin, etc)

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

The worker can be implemented in any language, but the api is designed
to return a json message that will call the perform class method and
pass in arguments to that method for processing:

    klass = Object.const_get(payload[:klass].capitalize)
    klass.perform(*payload[:args])


Which means, when you build your remote worker app, you want to use
event machine to run a periodic timer every xxx seconds:

    EM.do |em|
      em.add_periodic_timer(3) do
        payload = Crack::JSON.parse(RestClient.get('/myqueue'))
        
        Cloudq::Job.perform(payload)
        RestClient.delete("/myqueue/#{payload[:id]}")
      end
    end

----

# Simple Worker Client

require 'cloudq_worker'
require 'donuts/bake'

Cloudq::Connection.url = 'http://cloudq.com'
Cloudq::Job.perform(:make_donuts, 3.seconds)


# Simple enqueue Client

require 'cloudq_publisher'

Cloudq::Connection.url = 'http://cloudq.com'
Cloudq::Job.enqueue(:make_donuts, 'Bake', :type => glazed)


---







