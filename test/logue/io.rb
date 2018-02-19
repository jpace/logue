#!/usr/bin/ruby -w
# -*- ruby -*-

require 'stringio'

module IOCapture  
  def capture_io
    begin
      orig_stdout = $stdout
      captured_stdout = $stdout = StringIO.new
      
      orig_stderr = $stderr
      captured_stderr = $stderr = StringIO.new

      yield

      return captured_stdout.string, captured_stderr.string
    ensure
      $stdout = orig_stdout
      $stderr = orig_stderr
    end
  end
end
