#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/line'
require 'logue/location'
require 'logue/location_format'
require 'logue/tc'

module Logue
  class LineTest < TestCase
    include LocationFormat::Defaults

    def self.location path, line, cls, meth
      Location.new path, line, cls, meth
    end

    def self.build_line_params
      path          = "/path/a/b/c"
      meth          = "m3"
      cls           = "c2"
      line          = 3
      exppathline   = sprintf "[%*s:%*d]", FILENAME, path, LINE, line
      explocmeth    = sprintf "{%*s}",     METHOD,   meth
      explocclsmeth = sprintf "{%*s}",     METHOD,   cls + "#" + meth
      obj3 = (0 .. 3).to_a
      Array.new.tap do |a|
        a << [ exppathline + " " + explocmeth,    "s1", location(path, line, nil, meth), "s1" ]
        a << [ exppathline + " " + explocclsmeth, "s1", location(path, line, "c2", meth), "s1" ]
        a << [ exppathline + " " + explocmeth,    "s1", location(path, line, nil, meth), "s1" ]
        a << [ exppathline + " " + explocmeth,    "s1: o2", location(path, line, nil, meth), "s1", "o2" ]
        a << [ exppathline + " " + explocmeth,    "s1: [0, 1, 2, 3] (#:4)", location(path, line, nil, meth), "s1", obj3 ]
      end
    end

    param_test build_line_params do |exploc, expmsg, loc, msg, obj = nil|
      line   = Line.new loc, msg, obj
      result = line.format LocationFormat.new
      assert_equal exploc + " " + expmsg, result
    end

    param_test build_line_params do |exploc, expmsg, loc, msg, obj = nil|
      line   = Line.new loc, msg, obj
      result = line.message_string
      assert_equal expmsg, result
    end
  end
end
