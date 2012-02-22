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
        mount_point = File.join(HsrHelpers::Base.temp_dir.path, 'mounts', @name)

        Logger.message "Unmount \"#{@name}\""
        `umount "#{mount_point}"`
      end
    
    end
  end
end