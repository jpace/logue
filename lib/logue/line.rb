#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/format'

module Logue
end

class Logue::Line
  attr_reader :location
  attr_reader :msg
  
  def initialize location, msg
    @location = location
    @msg = msg
  end

  def write format, out = $stdout
    logmsg = @location.format format
    logmsg += " " + @msg
    out.puts logmsg
  end
end
