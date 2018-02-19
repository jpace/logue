#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'

module Logue
end

class Logue::Line
  attr_reader :location
  attr_reader :msg
  
  def initialize location, msg
    @location = location
    @msg = msg
  end

  def format format
    logmsg = @location.format format
    logmsg + " " + @msg
  end
end
