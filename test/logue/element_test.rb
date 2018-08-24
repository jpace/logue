#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/element'
require 'test_helper'

module Logue
  class ElementTest < Test::Unit::TestCase
    include Paramesan

    def test_init
      obj = "xyz"
      lo = Element.new obj
      assert_same obj, lo.object
    end

    def test_write
      obj = Element.new "xyz"
      io = StringIO.new
      obj.write io
      io.close
      assert_equal "xyz", io.string
    end
  end
end
