#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = level.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

require 'logue/level'

module Logue
  class Log
    # legacy module that is replaced by Logue::Level
    module Severity
      include Logue::Level
    end
  end
end
