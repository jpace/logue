#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/format'

module Logue
end

class Logue::Writer
  attr_accessor :out
  
  def initialize out = $stdout
    @out = out
  end

  def write fmt, stack, nframes, cls = nil
    stack[0 ... nframes].each do |frame|
      path = frame.absolute_path
      lineno = frame.lineno
      func = frame.label
      @out.puts fmt.format path, lineno, cls, func
    end
  end
end
