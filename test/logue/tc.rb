#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'paramesan'

module Logue
  class TestCase < Test::Unit::TestCase
    include Paramesan
  end
end
