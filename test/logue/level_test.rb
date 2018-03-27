#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/level'
require 'test_helper'

module Logue
  class LevelTest < Test::Unit::TestCase
    include Paramesan

    def self.build_compare_params
      levels =  [ Level::DEBUG, Level::INFO, Level::WARN, Level::ERROR, Level::FATAL ]
      Array.new.tap do |a|
        (1 ... levels.length).each do |n|
          levels[n .. -1].each do |level|
            a << [ true, levels[n - 1], level ]
            a << [ false, level, levels[n - 1] ]
          end
        end
      end
    end

    param_test build_compare_params do |exp, x, y|
      assert_equal exp, x < y
    end
  end
end
