#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/level'
require 'test_helper'
require 'paramesan'

module Logue
  class LevelTest < Test::Unit::TestCase
    include Paramesan

    param_test [
      [ 0, Logue::Level::DEBUG ], 
      [ 1, Logue::Level::INFO ],  
      [ 2, Logue::Level::WARN ],  
      [ 3, Logue::Level::ERROR ], 
      [ 4, Logue::Level::FATAL ], 
    ].each do |exp, level|
      assert_equal exp, level
    end
  end
end
