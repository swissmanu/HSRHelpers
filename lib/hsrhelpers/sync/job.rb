module HsrHelpers
  module Sync
    class Job
      
      class << self
        def all
          @all ||= []
        end
        
        def find(label)
          label = label.to_s
          
          all.each do |job|
            return job if job.label == label
          end
          #raise Error!
          puts "error finding job with label '#{label}'!"
        end
      end
      
      attr_reader :label
      attr_accessor :one_way_mirrors
      attr_accessor :mounts
      attr_accessor :unmounts
    
      def initialize(label, &block)
        @label = label.to_s
      
        @one_way_mirrors = Array.new
        @mounts = Array.new
        @unmounts = Array.new
      
        instance_eval(&block) if block_given?
        Job.all << self
      end
    
      def one_way(name, &block)
        @one_way_mirrors << OneWayMirror.new(self, name, &block)
      end
    
      def mount(name, &block)
        @mounts << Mount.new(self, name, &block)
      end
    
      def unmount(name)
        @unmounts << Unmount.new(self, name)
      end
    
      ##
      # Runs this job.
      def perform!
        Logger.message "Start job \"#{@label}\""
        begin 
          if @one_way_mirrors.any?
            @mounts.each          { |m| m.perform! }
            @one_way_mirrors.each { |m| m.perform! }
            @unmounts.each        { |u| u.perform! }
          end
        rescue => exception
          puts exception
        end
      end
    
    end
  end
end