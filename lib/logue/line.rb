#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'

module Logue
  class Line
    attr_reader :location
    attr_reader :msg
    
    def initialize location, msg
      @location = location
      @msg = msg
    end

    def format locformat
      logmsg = @location.format locformat
      logmsg + " " + @msg
    end
  end
end
