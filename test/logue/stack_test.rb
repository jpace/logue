require 'logue/stack'
require 'logue/tc'

module Logue
  class StackTest < TestCase
    def test_init
      lnum = __LINE__
      result = Stack.new
      x = result.frames[0]
      y = result.frames[1]
      assert_all [
                   lambda { assert_equal "stack_test.rb", Pathname.new(x.path).basename.to_s },
                   lambda { assert_equal lnum + 1, x.line },
                   lambda { assert_equal "test_init", x.method },
                   lambda { assert_equal "testcase.rb", Pathname.new(y.path).basename.to_s },
                   lambda { assert_equal "run_test", y.method },
                 ]
    end

    def second
      lnum = __LINE__
      result = Stack.new

      x = result.frames[0]
      y = result.frames[1]
      assert_all [
                   lambda { assert_equal "stack_test.rb", Pathname.new(x.path).basename.to_s },
                   lambda { assert_equal lnum + 1, x.line },
                   lambda { assert_equal "second", x.method },
                   lambda { assert_equal "(eval)", y.path },
                   lambda { assert_equal 2, y.line },
                   lambda { assert_equal "first", y.method },
                 ]
    end

    def test_from_eval
      instmeth = Array.new.tap do |a|
        a << 'def first'
        a << '  second'
        a << 'end'
      end
      instance_eval instmeth.join "\n"
      first
    end
  end
end
