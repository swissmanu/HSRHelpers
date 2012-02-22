module HsrHelpers
  module Sync
    module Utils
      
      ##
      # Creates a directory if it is not already existing.
      # Uses mkdir_p to create complete directory-trees.
      def create_dir_if_missing(*names)
        names.each do |name|
          FileUtils.mkdir_p(name) unless File.directory?(name)
        end
      end
    
      def delete_dir(path)
        Dir.delete(path)
      end
    
      ##
      # Ensures that a path has a trailing slash.
      def check_path(path)
        checked_path = path
        checked_path = checked_path << '/' if !path.end_with?('/')
      
        return checked_path
      end
      
    end
  end
end