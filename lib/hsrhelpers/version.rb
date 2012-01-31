# encoding: utf-8

module HsrHelpers
  class Version

    MAJOR, MINOR, PATCH = 1, 0, 0

    def self.major
      MAJOR
    end

    def self.minor
      MINOR
    end

    def self.patch
      PATCH
    end

    def self.current
      "#{major}.#{minor}.#{patch}"
    end

  end
end
