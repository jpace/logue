#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'
require 'logue/frame'

module Logue
  class Stack
    attr_reader :frames
    
    def initialize
      # caller_locations requires Ruby 2.0+
      locations = caller_locations 2
      @frames = locations.collect do |loc|
        Frame.new path: loc.absolute_path, line: loc.lineno, method: loc.label
      end
    end
  end
end
