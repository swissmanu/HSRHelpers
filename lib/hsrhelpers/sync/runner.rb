module HsrHelpers
  module Sync
    module Runner
      
      ##
      # Loads an array of job-files and runs them.
      def sync!(job_files)
        Logger.message '== Start Sync Submodule =='
        
        job_files.each do |job_file|
          job_file += '.rb' if !job_file.end_with?('.rb')
          Logger.message "Load job(s) from \"#{job_file}\""
          
          Job.module_eval(File.read(job_file));
        end
        
        Job.all.each { |j| j.perform! }
      end
      
    end
  end
end