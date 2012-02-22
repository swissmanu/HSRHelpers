module HsrHelpers
  module Sync  
    class OneWayMirror
      include Utils
    
      attr_accessor :name
      attr_accessor :excludes
      attr_accessor :tasks
      attr_accessor :source_base_path
      attr_accessor :target_base_path
    
      def initialize(job, name, &block)
        @job = job
        @name = name.to_s
      
        @tasks = Array.new
        @excludes = Array.new
      
        instance_eval(&block) if(block_given?)
      end
    
      def mirror(source, target)
        @tasks << { :source => check_path(source.to_s), :target => check_path(target.to_s) }
      end

      def source_base(base)
        @source_base_path = check_path(base.to_s)
      end
    
      def target_base(base)
        @target_base_path = check_path(base.to_s)
      end
    
      def exclude(path)
        @excludes << path.to_s
      end
    
      ##
      # Syncs data with rsync
      def perform!
        exclude_filter = ''
        @excludes.each { |e| exclude_filter << " --exclude '#{e}' " }
      
        @tasks.each do |task|
          prepared_source = prepare_path(task[:source], @source_base_path)
          prepared_target = prepare_path(task[:target], @target_base_path)
          Logger.message "Perform One-Way-Mirror:"
          Logger.message " - Source: #{prepared_source}"
          Logger.message " - Target: #{prepared_target}"

          create_dir_if_missing(prepared_target)
          
          `rsync --archive -u -v #{exclude_filter} "#{prepared_source}" "#{prepared_target}"`
        end
      end
    
      private
    
      def prepare_path(path, base_path)
        path = File.join(base_path.to_s, path) if !base_path.nil?
        
        mounts = File.join(HsrHelpers::Base.temp_dir.path, 'mounts', '')
        path = path.gsub(":", mounts)
      end
    
    end
  end
end