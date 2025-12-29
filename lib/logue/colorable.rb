require 'rainbow/x11_color_names'
require 'rainbow/color'
require 'logue/level'
require 'logue/core/dynamic'

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
  module Colorable
    include Dynamic

    def method_missing meth, *args, &blk
      code = valid_colors[meth]
      if code
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

    def valid_colors
      # Rainbow::X11ColorNames::NAMES
      Rainbow::Color::Named::NAMES
    end
  end
end
