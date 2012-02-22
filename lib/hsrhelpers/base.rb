module HsrHelpers
  class Base
  
    ##
    # Returns the path of a temporary directory
    def self.temp_dir options = {:remove => true}
      @temp_dir ||= begin
        require 'tmpdir'
        require 'fileutils'
        called_from = File.basename caller.first.split(':').first, ".rb"
        path = File.join(Dir::tmpdir, "#{called_from}_#{Time.now.to_i}_#{rand(1000)}")
        Dir.mkdir(path)
        at_exit {FileUtils.rm_rf(path) if File.exists?(path)} if options[:remove]
        File.new path
      end
    end
    
  end
  
end