require "yaml"

module HsrHelpers
  
  class Configuration
    
    ##
    # Holds a loaded configuration
    @@config = nil
    
    ##
    # Return a specific config value
    def self.get(*keys)
      Configuration.ensure_config_is_loaded
      
      value = @config
      keys.each do |key|
        if !value.has_key?(key)
          value = nil
          break
        end
        value = value[key]
      end
      
      value
    end
    
    def self.ensure_config_is_loaded
      @config = YAML.load_file(File.expand_path("../../../config.yml", __FILE__)) if @config.nil?
    end
    
  end
  
end
    