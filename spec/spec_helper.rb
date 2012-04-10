require 'bundler'
Bundler.require 'test'
require 'webmock/rspec'
require 'vcr'
require File.expand_path("../../lib/kayakfares.rb", __FILE__)

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path('../responses', __FILE__)
  c.hook_into :webmock
  c.default_cassette_options = {:record => :once}
end