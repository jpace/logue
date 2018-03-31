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
require 'logue/location_format'

module Logue
  module LegacyLogger
    # this is deprecated and ignored:
    def trim= what
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

    def output
      writer.output
    end

    def output= obj
      writer.output = obj
    end

    def colorize_line
      writer.colorize_line
    end

    def colorize_line= b
      writer.colorize_line = b
    end

    def set_default_widths
      self.format = LocationFormat.new
    end
    
    def set_color lvl, color
      writer.colors[lvl] = color
    end
  end
end
