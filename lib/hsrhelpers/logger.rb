module HsrHelpers
  
  ##
  # thanks https://github.com/meskyanichi/backup
  class Logger
    
    def self.message(string)
      puts loggify(:message, string, :green) unless quiet?
    end

    def self.error(string)
      puts loggify(:error, string, :red) unless quiet?
    end

    def self.warn(string)
      puts loggify(:warning, string, :yellow) unless quiet?
    end

    def self.normal(string)
      puts string unless quiet?
    end

    ##
    # Builds the string in a log format with the date/time, the type (colorized)
    # based on whether it's a message, notice or error, and the message itself.
    # ANSI color codes are only used in the console, and are not written to the log
    # since it doesn't do anything and just adds more unnecessary bloat to the log file
    def self.loggify(type, string, color = false)
      return "[#{type}] #{string}" unless color
      "[#{send(color, type)}] #{string}"
    end
    
    ##
    # Invokes the #colorize method with the provided string
    # and the color code "32" (for green)
    def self.green(string)
      colorize(string, 32)
    end

    ##
    # Invokes the #colorize method with the provided string
    # and the color code "33" (for yellow)
    def self.yellow(string)
      colorize(string, 33)
    end

    ##
    # Invokes the #colorize method the with provided string
    # and the color code "31" (for red)
    def self.red(string)
      colorize(string, 31)
    end

    ##
    # Wraps the provided string in colorizing tags to provide
    # easier to view output to the client
    def self.colorize(string, code)
      "\e[#{code}m#{string}\e[0m"
    end

    ##
    # Returns 'true' (boolean) if the QUIET constant is defined
    # By default it isn't defined, only when initializing Backup using
    # the '--quite' (or '-q') option in the CLI (e.g. backup perform -t my_backup --quiet)
    def self.quiet?
      const_defined?(:QUIET) && QUIET
    end
  end
end