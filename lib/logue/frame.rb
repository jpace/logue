#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'

module Logue
  class Frame
    FRAME_RE = Regexp.new '(.*):(\d+)(?::in \`(.*)\')?'
    
    attr_reader :path
    attr_reader :line
    attr_reader :method

    def initialize args
      if entry = args[:entry]
        md = FRAME_RE.match entry
        # Ruby 1.9 expands the file name, but 1.8 doesn't:
        @path   = Pathname.new(md[1]).expand_path
        @line   = md[2].to_i
        @method = md[3] || ""
      else
        @path   = Pathname.new(args[:path])
        @line   = args[:line]
        @method = args[:method]
      end
    end

    def to_s
      [ :path, :line, :method ].collect { |field| "#{field}: " + send(field).to_s }.join ", "
    end
  end
end
