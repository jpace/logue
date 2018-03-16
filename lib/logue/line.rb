#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'

module Logue
  class Line
    attr_reader :location
    attr_reader :msg
    attr_reader :block
    
    def initialize location, msg, &blk
      @location = location
      @msg = msg
      @block = blk
    end

    def format locformat
      logmsg = @location.format locformat
      logmsg += " "
      logmsg += @block ? @block.call.to_s : @msg
    end
  end
end
