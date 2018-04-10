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

    def location_string locformat
      @location.format locformat
    end

    def message_string
      if @block
        @block.call.to_s
      elsif @obj
        "#{@msg}: #{@obj}"
      else
        "#{@msg}"
      end
    end

    def format locformat
      location_string(locformat) + " " + message_string
    end
  end
end
