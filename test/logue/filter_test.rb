#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/filter'
require 'test_helper'

module Logue
  class FilterTest < Test::Unit::TestCase
    include Paramesan

    param_test [
      [ Array.new, Array.new, Array.new ],
      [ %w{ abc }, Array.new, Array.new, ignored_files: %w{ abc } ],
      [ Array.new, %w{ abc }, Array.new, ignored_methods: %w{ abc } ],
      [ Array.new, Array.new, %w{ abc }, ignored_classes: %w{ abc } ],
    ] do |expfiles, expmethods, expclasses, *args|
      filter = Filter.new(*args)
      assert_equal expfiles,   filter.ignored_files
      assert_equal expmethods, filter.ignored_methods
      assert_equal expclasses, filter.ignored_classes
    end

    def self.build_ignore_params
      Array.new.tap do |a|
        a << [ :log_file,   :ignore_file,   :ignored_files ]
        a << [ :log_method, :ignore_method, :ignored_methods ]
        a << [ :log_class,  :ignore_class,  :ignored_classes ]
      end
    end

    param_test build_ignore_params do |log_meth, ignore_meth, ignored_meth|
      filter = Filter.new
      assert_empty filter.send(ignored_meth)
      filter.send ignore_meth, "abc"
      assert_equal %w{ abc }, filter.send(ignored_meth)
    end

    param_test build_ignore_params do |log_meth, ignore_meth, ignored_meth|
      filter = Filter.new
      assert_empty filter.send(ignored_meth)
      filter.send ignore_meth, "abc"
      assert_equal %w{ abc }, filter.send(ignored_meth)
      filter.send log_meth, "abc"
      assert_empty filter.send(ignored_meth)
    end

    def self.add_log_params ary, exp, *args
      ary << [ exp, "fabc", "cdef", "mghi", *args ]
    end

    def self.build_log_params
      Array.new.tap do |a|
        add_log_params a, true
        add_log_params a, false, ignored_files: %w{ fabc }
        add_log_params a, true,  ignored_files: %w{ fxyz }
        add_log_params a, false, ignored_classes: %w{ cdef }
        add_log_params a, true,  ignored_classes: %w{ cxyz }
        add_log_params a, false, ignored_methods: %w{ mghi }
        add_log_params a, true,  ignored_methods: %w{ mxyz }
      end
    end                      

    param_test build_log_params do |exp, fname, cls, meth, *args|
      filter = Filter.new(*args)
      result = filter.log? fname, cls, meth
      assert_equal exp, result
    end

    def self.build_equals_params
      x = %w{ x }
      y = %w{ y }
      Array.new.tap do |a|
        a << [ true,  Filter.new ]
        a << [ true,  Filter.new(ignored_files: x),   ignored_files: x ]
        a << [ false, Filter.new(ignored_files: x),   ignored_files: y ]
        a << [ true,  Filter.new(ignored_classes: x), ignored_classes: x ]
        a << [ false, Filter.new(ignored_classes: x), ignored_classes: y ]
        a << [ true,  Filter.new(ignored_methods: x), ignored_methods: x ]
        a << [ false, Filter.new(ignored_methods: x), ignored_methods: y ]
      end
    end

    param_test build_equals_params do |exp, x, *args|
      filter = Filter.new(*args)
      assert_equal exp, x == filter
    end
  end
end
