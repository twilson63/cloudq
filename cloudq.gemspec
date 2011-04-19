# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)


Gem::Specification.new do |s|
  s.name        = "cloudq"
  s.version     = "0.0.6"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tom Wilson"]
  s.email       = ["tom@jackhq.com"]
  s.homepage    = "http://github.com/twilson63/cloudq"
  s.summary     = "A Ruby Framework for a Remote Job Queue Server"
  s.description = "The Cloudq Framework makes it easy to build remote job queue servers"
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "rspec", ">= 2.5.0"
  s.add_development_dependency "rack-test", ">= 0"

  s.add_dependency "bundler", ">= 0"
  s.add_dependency "thin", ">= 0"
  s.add_dependency "sinatra", ">= 0"
  s.add_dependency "bson_ext", ">= 0"
  s.add_dependency "mongo_mapper", ">= 0"
  s.add_dependency "eventmachine", ">= 1.0.0.beta.3"
  s.add_dependency "async_sinatra", ">= 0"
  s.add_dependency "workflow", ">= 0"

  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE readme.md bin/cloudq)
  s.require_path = ['lib']
  s.executables = ["cloudq"]
end

