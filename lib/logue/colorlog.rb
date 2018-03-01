#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = colorlog.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

require 'rainbow/x11_color_names'
require 'rainbow/color'
require 'logue/level'

#
# == ColorLog
#
# This class logs messages using terminal colors, forwarding them to a log method.
#
# == Examples
#
# See the unit tests in colorlog_test.rb
# 

module Logue
  module ColorLog
    def method_missing meth, *args, &blk
      # validcolors = Rainbow::X11ColorNames::NAMES
      validcolors = Rainbow::Color::Named::NAMES
      if code = validcolors[meth]
        add_color_method meth.to_s, code + 30
        send meth, *args, &blk
      else
        super
      end
    end

    def respond_to? meth
      # validcolors = Rainbow::X11ColorNames::NAMES
      validcolors = Rainbow::Color::Named::NAMES
      validcolors.include?(meth) || super
    end

    def add_color_method color, code
      instmeth = Array.new.tap do |a|
        a << 'def ' + color.to_s + '(msg = "", lvl = Logue::Level::DEBUG, depth = 1, cname = nil, &blk)'
        a << '  log("\e[' + code.to_s + 'm#{msg}\e[0m", lvl, depth + 1, cname, &blk)'
        a << 'end'
      end
      instance_eval instmeth.join "\n"
    end
  end
end
