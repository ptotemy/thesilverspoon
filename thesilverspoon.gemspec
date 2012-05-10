# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "thesilverspoon/version"

Gem::Specification.new do |s|
  s.name        = "thesilverspoon"
  s.version     = Thesilverspoon::VERSION
  s.authors     = ["Ptotem"]
  s.email       = ["info@ptotem.com"]
  s.homepage    = "https://github.com/ptotemy/thesilverspoon"
  s.summary     = %q{Let your Rails App be born with a silver spoon in its mouth}
  s.description = %q{This gem preps a new Rails app with some of the best Rails gems and Jquery sweetness available( Twitter-Bootstrap, Devise, CanCan, Rails Admin, Spreadsheet, ) Not only does it takes care of the installation of these gems, it also extends your scaffolds to give aesthetically improved views. Further, apart from the standard scaffold views, it also creates an AJAX driven integrated view for your scaffold. It dries up your controllers and makes your models friendlier by adding schema stubs and standard validation options. Expect Cucumber integration in our next version}

  s.rubyforge_project = "thesilverspoon"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"




s.add_dependency 'gritter'
s.add_dependency 'spreadsheet'
s.add_dependency 'carrierwave'
s.add_dependency 'devise'
s.add_dependency 'cancan'
s.add_dependency 'nifty-generators'
s.add_dependency 'cells'






end
