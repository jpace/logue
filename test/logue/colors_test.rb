#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/colors'
require 'test/unit'

class ColorsTest < Test::Unit::TestCase
  def test_valid_colors
    result = Colors.valid_colors
    assert_equal [ :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white, :default ], result.keys
  end
end
