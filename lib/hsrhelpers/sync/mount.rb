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
          mount_point = File.join(HsrHelpers::Base.temp_dir.path, 'mounts', @name)
          
          Logger.message "Mount SMB share under \"#{@name}\""
          create_dir_if_missing "#{mount_point}"
          `mount_smbfs #{@path} "#{mount_point}"`
        else
          Logger.error 'Only SMB file systems are mountable at the moment!'
        end
      end
    
    end
  end
end