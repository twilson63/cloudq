# Cloudq Framework

Cloudq is a rack-based job queue framework.  

## What does that mean?

Cloudq is a job queue, but instead of containing a ton of features, it focuses on doing job queue basics:

* Publish a Job to a Queue
* Reserve a Job from a Queue
* Delete a Job from a Queue

Using the rack application architecture, and taking advantage of rack middleware, adding features or embedding
into other applications is very easy.

Currently, it does depend on access to a mongodb datastore.  Either the standard localhost or you can 
set the MONGOHQ_URL env variable.  This does not mean that any application you join with Cloudq needs to write to mongodb, just the job queue is connected to mongo.

# What about security?
# What about monitoring?
# etc???

The answer is simple, RACK MIDDLEWARE!  If you want to implement ssl encryption and enforce SSL traffic, use
rack middleware.  If you want to attach a slick admin 
interface that monitors your queues, then use the rack
map function to attach another rack-based application to your config.ru file.

It really is that easy, and Cloudq gives you the flexibility to integrate almast anyway you can think of.

# How do I get started?

1. Install Mongodb

First you need to install MongoDb and have a mongodb service running.  Or you can signup for a free account on
MongoHq.com.  

2. Install Ruby version 1.9.2 or above

Make sure you have Ruby 1.9.2 installed on your machine, if you do not have 1.9.2, check out [RVM](https://rvm.beginrescueend.com/).  Ruby 1.9.2 comes with rubygems, which will allow you to install the cloudq gem.

3. Install the Cloudq Gem

``` shell
gem install cloudq
```

    
4. Build your cloudq server

```
cloudq [your name]
```
    
This will create a directory and add a config.ru and Gemfile.  And if you don't want to add any other features,
you are good to go.  All you have to do is cd into your directory and run:


    thin start
    
And your cloudq server is up and running!  

----------------

# Deploy

You can deploy Cloudq just like any rails application, but Heroku is an awesome platform to deploy:
    
    # make sure you have your project in a git repo
    
    git init
    git add .
    git commit -am "First Commit"
    
    # deploy to heroku in 2 simple steps
    
    heroku create
    git push heroku master
    

# Contribution

Feel free to for fork the code and make pull requests.. But also create some Rack Middleware that helps add an
awesome feature stack to the Cloudq.

Here is a link to an awesome chapter in the Rails 3 in a Nutshell on Rack.

[http://rails-nutshell.labs.oreilly.com/ch07.html](http://rails-nutshell.labs.oreilly.com/ch07.html)


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

```
gem install cloudq_client
```

``` ruby
require 'cloudq_client/publish'

Cloudq::Connection.url = 'http://donuts.com'
Cloudq::Publish.new(:make_donuts).job('Donut', :types => [:glazed,
:chocolate])

```


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







