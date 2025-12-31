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
require 'logue/elements/element_log'

#
# == Log2
#
# Log2 uses the extended format for formatting complex elements instead
# of using only their to-string methods.
# 
# See Log.
#

module Logue
  class Log2 < ElementLog
  end
end
