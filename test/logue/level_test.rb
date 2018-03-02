#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/level'
require 'test_helper'
require 'paramesan'

module Logue
  class LevelTest < Test::Unit::TestCase
    include Paramesan

    param_test [
      [ 0, Level::DEBUG ], 
      [ 1, Level::INFO ],  
      [ 2, Level::WARN ],  
      [ 3, Level::ERROR ], 
      [ 4, Level::FATAL ], 
    ].each do |exp, level|
      assert_equal exp, level
    end
  end
end
