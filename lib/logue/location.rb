#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'

module Logue
end

class Logue::Location
  attr_reader :path
  attr_reader :lineno
  attr_reader :cls
  attr_reader :function
  
  def initialize path, lineno, cls, function
    @path = path
    @lineno = lineno
    @cls = cls
    @function = function
  end

  def format locformat
    locformat.format @path, @lineno, @cls, @function
  end
end
