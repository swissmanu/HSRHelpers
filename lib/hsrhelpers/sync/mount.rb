module HsrHelpers
  module Sync
    class Mount
      include Utils
    
      attr_accessor :name
      attr_accessor :type
      attr_accessor :path
    
      def initialize(job, name, &block)
        @job = job
        @name = name.to_s
      
        instance_eval(&block) if(block_given?)
      end
    
      def type(type)
        @type = type
      end
    
      def path(path)
        @path = path
      end
    
      def perform!
        if(@type == :smb)
          Logger.message "Mount SMB share under \"mounts/#{@name}\""
          
          create_dir_if_missing "mounts/#{@name}"
          `mount_smbfs #{@path} "mounts/#{@name}"`
        else
          Logger.error 'Only SMB file systems are mountable at the moment!'
        end
      end
    
    end
  end
end