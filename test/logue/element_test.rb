#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/element'
require 'logue/tc'
require 'stringio'

module Logue
  class ElementTest < TestCase
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

    def test_write_enumerable
      ary = %w{ this is a test }
      obj = Element.new ary
      io = StringIO.new
      obj.write io
      io.close
      assert_equal '["this", "is", "a", "test"] (#:4)', io.string
    end
  end
end
