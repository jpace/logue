#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/frame'

module Logue
  class Stack
    attr_reader :frames
    
    def initialize depth: 2
      # caller_locations requires Ruby 2.0+
      locations = caller_locations depth
      @frames = locations.collect do |loc|
        # no absolute_path from "(eval)"
        Frame.new path: loc.absolute_path || loc.path, line: loc.lineno, method: loc.label
      end
    end

    def filtered
      logframe = @frames.rindex { |frm| frm.path.include? "logue/lib/logue" }
      @frames[logframe + 1 .. -1]
    end
  end
end
