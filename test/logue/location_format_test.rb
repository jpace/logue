#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/location_format'
require 'test_helper'

module Logue
  class LocationFormatTestCase < Test::Unit::TestCase
    include Paramesan

    param_test [
      [ 8, 7, 11, file: 8, line: 7, method: 11 ],
      [ "08", 7, 11, file: "08", line: 7, method: 11 ],
      [ LocationFormat::Defaults::FILENAME, LocationFormat::Defaults::LINE, LocationFormat::Defaults::METHOD ]
    ] do |expfile, expline, expmethod, *args|
      fmt = LocationFormat.new(*args)
      assert_equal expfile, fmt.file
      assert_equal expline, fmt.line
      assert_equal expmethod, fmt.method
    end          

    def self.build_format_params
      Array.new.tap do |a|
        a << [ "[.../the/directory/abc.t  :   1] {block (2 levels) in }", "/a/long/path/to/the/directory/abc.t", 1, nil,    "block (2 levels) in one" ]
        a << [ "[/srv/dir/abc.t           :   1] {block (2 levels) in }", "/srv/dir/abc.t",                      1, nil,    "block (2 levels) in one" ]
        a << [ "[/srv/dir/abc.t           :   1] {c123#m456           }", "/srv/dir/abc.t",                      1, "c123", "m456" ]
        a << [ "[/srv/dir/abc.t           :   1] {m456                }", "/srv/dir/abc.t",                      1, nil,    "m456" ]
      end
    end

    param_test build_format_params do |expected, path, line, cls, func|
      result = LocationFormat.new.format path, line, cls, func
      assert_equal expected, result
    end

    def test_format_string
      exp    = "[%-25s:%4d] {%-20s}"
      result = LocationFormat.new.format_string
      assert_equal exp, result
    end
  end
end
