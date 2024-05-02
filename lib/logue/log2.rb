#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = log2.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

require 'logue/log'
require 'logue/writer2'

#
# == Log2
#
# Log2 uses the extended format for formatting complex elements instead
# of using only their to-string methods.
# 
# See Log.
#

module Logue
  class Log2 < Log
    def self.reset
      # We're setting Log.@logger, used therein, not Log2.@logger, which
      # wouldn't be. This is preferable to using class variables.
      logger = Logger.new writer: Writer2.new
      Log.instance_variable_set :@logger, logger
    end

    reset
  end
end
