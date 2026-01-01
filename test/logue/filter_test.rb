require 'logue/filter'
require 'logue/tc'

module Logue
  class FilterTest < TestCase
    param_test [
                 [Array.new, Array.new, Array.new],
                 [%w{ abc }, Array.new, Array.new, files: %w{ abc }],
                 [Array.new, %w{ abc }, Array.new, methods: %w{ abc }],
                 [Array.new, Array.new, %w{ abc }, classes: %w{ abc }],
               ] do |expfiles, expmethods, expclasses, *args|
      filter = Filter.new(*args)
      assert_all [
                   lambda { assert_equal expfiles, filter.files },
                   lambda { assert_equal expmethods, filter.methods },
                   lambda { assert_equal expclasses, filter.classes },
                 ]
    end

    def self.add_log_params ary, exp, *args
      ary << [exp, "fabc", "cdef", "mghi", *args]
    end

    def self.build_log_params
      Array.new.tap do |a|
        add_log_params a, true
        add_log_params a, false, files: %w{ fabc }
        add_log_params a, true, files: %w{ fxyz }
        add_log_params a, false, classes: %w{ cdef }
        add_log_params a, true, classes: %w{ cxyz }
        add_log_params a, false, methods: %w{ mghi }
        add_log_params a, true, methods: %w{ mxyz }
      end
    end

    param_test build_log_params do |exp, fname, cls, meth, *args|
      filter = Filter.new(*args)
      result = filter.log? fname, cls, meth
      assert_equal exp, result
    end
  end
end
