require 'bundler/setup'
require 'json'
require 'mongo_mapper'
require 'sinatra'
require 'sinatra/async'
require 'workflow'

require_relative 'rack/params'

module Cloudq; end

require_relative 'cloudq/job'
require_relative 'cloudq/app'


