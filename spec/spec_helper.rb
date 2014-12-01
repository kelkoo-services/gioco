# Configure Rails Envinronmnt
require 'coveralls'
require 'redis'
Coveralls.wear!

$redis = Redis.connect(url: 'redis://127.0.0.1:6379/')

require 'rake'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
Rails.backtrace_cleaner.remove_silencers!
