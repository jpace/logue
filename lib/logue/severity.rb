#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = severity.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

module Logue
  class Log
    module Severity
      DEBUG = 0
      INFO  = 1
      WARN  = 2
      ERROR = 3
      FATAL = 4
    end
  end
end
