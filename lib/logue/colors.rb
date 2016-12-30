#!/usr/bin/ruby -w
# -*- ruby -*-
#
# = colors.rb
#
# Logging Module
#
# Author:: Jeff Pace <jeugenepace@gmail.com>
# Documentation:: Author
#

require 'rainbow/x11_color_names'
require 'rainbow/color'

class Colors
  def self.valid_colors
    Rainbow::Color::Named::NAMES
  end
end