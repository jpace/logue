#!/usr/bin/ruby -w
# -*- ruby -*-

class LogTestee 
  def color_test
    Log.blue "azul"
  end

  def format_test
    Log.log "tamrof"
  end

  def log_all
    # I could make this an instance variable, but I want to check the method
    # names in the output string.

    Log.log   "hello, world?"
    Log.debug "hello, world?"
    Log.info  "hello, world?"
    Log.warn  "EXPECTED OUTPUT TO STDERR: hello, world." # will go to stderr
    Log.error "EXPECTED OUTPUT TO STDERR: hello, world." # will go to stderr
    Log.stack "hello, world?"
  end

  def log_block
    Log.debug { "block party" }
  end

  def log_foregrounds
    Log.white "white wedding"
    Log.blue "blue iris"
  end

  def log_backgrounds
    Log.on_cyan "red"
  end
end
