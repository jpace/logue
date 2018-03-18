#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = loggable.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

require 'logue/log'
require 'logue/colors'

#
# == Loggable
#
# Including this module in a class gives access to the logger methods.
# 
# == Examples
#
# See the unit tests in log_test.rb
#
# == Usage
#
#  class YourClass
#    include Logue::Loggable
#
#    def some_method(...)
#      log "my message"
# 
#  That will log from the given class and method, showing the line number from
#  which the logger was called.
#
#    def another_method(...)
#      stack "my message"
# 
#  That will produce a stack trace from the given location.
# 

module Logue
  module Loggable
    # Logs the given message, including the class whence invoked.
    def log msg = "", lvl = Log::DEBUG, &blk
      delegate_log_class.log msg, lvl, self.class.to_s, &blk
    end

    def debug msg = "", &blk
      delegate_log_class.debug msg, self.class.to_s, &blk
    end

    def info msg = "", &blk
      delegate_log_class.info msg, self.class.to_s, &blk
    end

    def warn msg = "", &blk
      delegate_log_class.warn msg, self.class.to_s, &blk
    end

    def error msg = "", &blk
      delegate_log_class.error msg, self.class.to_s, &blk
    end

    def fatal msg = "", &blk
      delegate_log_class.fatal msg, self.class.to_s, &blk
    end

    def stack msg = "", lvl = Log::DEBUG, &blk
      delegate_log_class.stack msg, lvl, self.class.to_s, &blk
    end

    def write msg = "", &blk
      delegate_log_class.write msg, self.class.to_s, &blk
    end

    def method_missing meth, *args, &blk
      # only handling foregrounds, not backgrounds
      if Colors::valid_colors[meth]
        add_color_method meth.to_s
        send meth, *args, &blk
      else
        super
      end
    end

    def respond_to? meth, include_all = false
      Colors::valid_colors.include?(meth) || super
    end

    def add_color_method color
      meth = Array.new.tap do |a|
        a << "def #{color}(msg = \"\", lvl = Log::DEBUG, cname = nil, &blk)"
        a << "  Log.send :#{color}, msg, lvl, self.class.to_s, &blk"
        a << "end"
      end
      instance_eval meth.join("\n")
    end

    def delegate_log_class
      Log
    end
  end
end
