#!/usr/bin/ruby -w
# -*- ruby -*-

require 'logue/filter'
require 'test_helper'
require 'paramesan'

module Logue
  class FilterTest < Test::Unit::TestCase
    include Paramesan

    param_test [
      [ Array.new, Array.new, Array.new ],
      [ %w{ abc }, Array.new, Array.new, ignored_files: %w{ abc } ],
      [ Array.new, %w{ abc }, Array.new, ignored_methods: %w{ abc } ],
      [ Array.new, Array.new, %w{ abc }, ignored_classes: %w{ abc } ],
    ].each do |expfiles, expmethods, expclasses, *args|
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

    param_test build_ignore_params.each do |log_meth, ignore_meth, ignored_meth|
      filter = Filter.new
      assert_empty filter.send(ignored_meth)
      filter.send ignore_meth, "abc"
      assert_equal %w{ abc }, filter.send(ignored_meth)
    end

    param_test build_ignore_params.each do |log_meth, ignore_meth, ignored_meth|
      filter = Filter.new
      assert_empty filter.send(ignored_meth)
      filter.send ignore_meth, "abc"
      assert_equal %w{ abc }, filter.send(ignored_meth)
      filter.send log_meth, "abc"
      assert_empty filter.send(ignored_meth)
    end
  end
end
