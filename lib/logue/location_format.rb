require 'logue/pathutil'

module Logue
  class LocationFormat
    module Defaults
      FILENAME = -25
      LINE     =   4
      METHOD   = -20
    end

    attr_accessor :file
    attr_accessor :line
    attr_accessor :method

    def initialize file: Defaults::FILENAME, line: Defaults::LINE, method: Defaults::METHOD
      @file   = file
      @line   = line
      @method = method
    end

    def format path, line, cls, methname
      name = cls ? cls.to_s + "#" + methname : methname
      path = PathUtil.trim_right path.to_s, @file.abs
      name = PathUtil.trim_left  name,      @method.abs
      sprintf format_string, path, line, name
    end

    def format_location location
      format location.path, location.line, location.cls, location.method
    end

    def format_string
      "[%#{@file}s:%#{@line}d] {%#{@method}s}"
    end

    def to_s
      inspect
    end
  end
end
