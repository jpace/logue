#!/usr/bin/ruby -w
# -*- ruby -*-

class LogTestee 
  def color_test
    Logue::Log.blue "azul"
  end

  def format_test
    Logue::Log.log "tamrof"
  end

  def log_all
    # I could make this an instance variable, but I want to check the method
    # names in the output string.

    Logue::Log.log   "hello, world?"
    Logue::Log.debug "hello, world?"
    Logue::Log.info  "hello, world?"
    Logue::Log.warn  "EXPECTED OUTPUT TO STDERR: hello, world." # will go to stderr
    Logue::Log.error "EXPECTED OUTPUT TO STDERR: hello, world." # will go to stderr
    Logue::Log.stack "hello, world?"
  end

  def log_block
    Logue::Log.debug { "block party" }
  end

  def log_foregrounds
    Logue::Log.white "white wedding"
    Logue::Log.blue "blue iris"
  end

  def log_backgrounds
    Logue::Log.on_cyan "red"
  end
end
