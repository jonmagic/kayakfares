# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kayakfares/version"

Gem::Specification.new do |s|
  s.name        = "kayakfares"
  s.version     = KayakFares::VERSION
  s.authors     = ["Jonathan Hoyt"]
  s.email       = ["jonmagic@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Library to return fares from the Kayak Search Gateway using Mechanize.}
  s.description = %q{Library to return fares from the Kayak Search Gateway using Mechanize.}

  s.rubyforge_project = "kayakfares"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'mechanize', '~> 2.3.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry'
end
