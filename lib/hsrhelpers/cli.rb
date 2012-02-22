module HsrHelpers

  ##
  # Provides a command line interface to the submodules of HSRHelper using
  # Thor.
  class CLI < Thor
    
    ##
    # Include Submodule-Runners:
    include Sync::Runner

    ##
    # [Sync]
    # Triggers the Sync-utility to run jobs from files.
    desc 'sync JOBFILES', "Loads one or more job files and runs their jobs.\n\nExamples:\n" +
                 "\sRuns /Users/manuel/HSR/hsrscripts.rb:\n\s\s\shsrhelpers sync /Users/manuel/HSR/hsrscripts.rb\n" +
                 "\sRuns hsrscripts.rb & dropbox.rb from current directory\n\s\s\shsrhelpers sync hsrscripts,dropbox"
    def sync(jobs)
      jobs = jobs.split(',')
      jobs = jobs.map! { |j| j.strip }
      sync! jobs
    end  

    ##
    # Display the version of HsrHelpers
    map "-v" => :version
    desc "version", "Display version information"
    def version
      puts "HsrHelpers #{HsrHelpers::Version.current}"
    end
      
  end
end