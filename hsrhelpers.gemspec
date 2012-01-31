# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/lib/hsrhelpers')

Gem::Specification.new do |gem|

  ##
  # General configuration / information
  gem.name        = 'hsrhelpers'
  gem.version     = HsrHelpers::Version.current
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = 'Manuel Alabor'
  gem.email       = 'manuel@alabor.me'
  gem.homepage    = 'http://www.github.com/swissmanu/hsrhelpers'
  gem.summary     = ''

  ##
  # Files and folder that need to be compiled in to the Ruby Gem
  gem.files         = %x[git ls-files].split("\n")
  #gem.test_files    = %x[git ls-files -- {spec}/*].split("\n")
  gem.require_path  = 'lib'

  ##
  # HSRHelpers CLI executable
  gem.executables   = ['hsrhelpers']

  ##
  # Gem dependencies
  gem.add_dependency 'thor',   ['~> 0.14.6']

end
