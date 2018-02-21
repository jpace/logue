#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'

module Logue
  class Frame
    FRAME_RE = Regexp.new '(.*):(\d+)(?::in \`(.*)\')?'
    
    attr_reader :absolute_path
    attr_reader :line
    attr_reader :function

    def initialize args
      if entry = args[:entry]
        md = FRAME_RE.match entry
        @absolute_path = Pathname.new(md[1]).expand_path.to_s
        @line          = md[2].to_i
        @function      = md[3] || ""
      else
        @absolute_path = args[:absolute_path]
        @line          = args[:line]
        @function      = args[:function]
      end
    end
  end
end
