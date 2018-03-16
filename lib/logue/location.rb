#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'

module Logue
  class Location
    attr_reader :path
    attr_reader :line
    attr_reader :cls
    attr_reader :method
    
    def initialize path, line, cls, method
      @path   = path
      @line   = line
      @cls    = cls
      @method = method
    end

    def format locformat
      locformat.format @path, @line, @cls, @method
    end
  end
end
