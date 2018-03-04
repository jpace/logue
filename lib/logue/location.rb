#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'

module Logue
  class Location
    attr_reader :path
    attr_reader :lineno
    attr_reader :cls
    attr_reader :method
    
    def initialize path, lineno, cls, method
      @path   = path
      @lineno = lineno
      @cls    = cls
      @method = method
    end

    def format locformat
      locformat.format @path, @lineno, @cls, @method
    end
  end
end
