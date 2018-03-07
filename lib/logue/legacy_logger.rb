#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = legacy_logger.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

require 'logue/filter'

module Logue
  module LegacyLogger
    def trim= what
      $stderr.puts "Logger#trim is deprecated, and ignored"
    end

    def ignore_file fname
      filter.ignore_file fname
    end
    
    def ignore_method methname
      filter.ignore_method methname
    end
    
    def ignore_class classname
      filter.ignore_class classname
    end

    def log_file fname
      filter.log_file fname
    end
    
    def log_method methname
      filter.log_method methname
    end
    
    def log_class classname
      filter.log_class classname
    end
  end
end
