module HsrHelpers
  module Sync
    class Unmount
      include Utils
    
      attr_accessor :name
    
      def initialize(job, name)
        @job = job
        @name = name.to_s
      end
    
      def perform!
        Logger.message "Unmount \"#{@name}\""
        `umount "mounts/#{@name}"`
        delete_dir "mounts/#{@name}"
      end
    
    end
  end
end