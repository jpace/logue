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
      if code = valid_colors[meth]
        add_color_method meth.to_s, code + 30
        send meth, *args, &blk
      else
        super
      end
    end

    def respond_to? meth
      valid_colors.include?(meth) || super
    end

    def methods all = true
      super + valid_colors.keys
    end

    def add_color_method color, code
      meth = Array.new.tap do |a|
        a << 'def ' + color.to_s + '(msg = "", lvl = Logue::Level::DEBUG, classname: nil, &blk)'
        a << '  log("\e[' + code.to_s + 'm#{msg}\e[0m", level: lvl, classname: classname, &blk)'
        a << 'end'
      end
      instance_eval meth.join "\n"
    end

    def valid_colors
      # Rainbow::X11ColorNames::NAMES
      Rainbow::Color::Named::NAMES
    end
  end
end
