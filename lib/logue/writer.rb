#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/format'

module Logue
end

class Logue::Writer
  attr_accessor :out
  attr_reader :format
  
  def initialize format, out = $stdout
    @format = format
    @out = out
  end

  def write stack, nframes, cls = nil
    stack[0 ... nframes].each do |frame|
      path   = frame.absolute_path
      lineno = frame.lineno
      func   = frame.label
      @out.puts @format.format path, lineno, cls, func
    end
  end

  def write_frame frame, cls = nil
    @out.puts @format.format frame.absolute_path, frame.lineno, cls, frame.label
  end
end
