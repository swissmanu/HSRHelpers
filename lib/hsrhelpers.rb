# Load Ruby core libraries:
require 'fileutils'
require 'yaml'

# Load 3rd party libraries
require 'thor'

##
# Loads the HsrHelpers
module HsrHelpers
  
  ##
  # Internal paths
  LIBRARY_PATH  = File.join(File.dirname(__FILE__), "hsrhelpers")
  SYNC_PATH     = File.join(LIBRARY_PATH, "sync")
  
  ##
  # Core HSRHelpers files:
  autoload :Base,           File.join(LIBRARY_PATH, "base")
  autoload :CLI,            File.join(LIBRARY_PATH, "cli")
  autoload :Configuration,  File.join(LIBRARY_PATH, "configuration")
  autoload :Logger,         File.join(LIBRARY_PATH, "logger")
  autoload :Version,        File.join(LIBRARY_PATH, "version")
  
  ##
  # Sync submodule:
  module Sync
    autoload :Runner,       File.join(SYNC_PATH, "runner")
    autoload :Job,          File.join(SYNC_PATH, "job")
    autoload :Utils,        File.join(SYNC_PATH, "utils")
    autoload :OneWayMirror, File.join(SYNC_PATH, "onewaymirror")
    autoload :Mount,        File.join(SYNC_PATH, "mount")
    autoload :Unmount,      File.join(SYNC_PATH, "unmount")
  end
  
end