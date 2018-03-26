#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'

module Logue
  class Line
    attr_reader :location
    attr_reader :msg
    attr_reader :obj
    attr_reader :block
    
    def initialize location, msg, obj = nil, &blk
      @location = location
      @msg = msg
      @obj = obj
      @block = blk
    end

    def format locformat
      logmsg = @location.format locformat
      logmsg << " "
      if @block
        logmsg << @block.call.to_s
      elsif @obj
        logmsg << "#{@msg}: #{@obj}"
      else
        logmsg << "#{@msg}"
      end
      logmsg
    end
  end
end
