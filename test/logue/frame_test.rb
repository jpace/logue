require 'logue/frame'
require 'logue/tc'

module Logue
  class FrameTest < TestCase
    param_test [
                 ["/path/a/b/c.rb", "labc", 3],
                 ["/path/d/e/f.rb", "lghi", 1],
                 ["/path/g/h/i.rb", "ljkl", 7],
                 ["(eval)", "labc", 3],
               ].each do |path, method, line|
      result = Frame.new path: path, method: method, line: line
      assert_all [
                   lambda { assert_equal path, result.path },
                   lambda { assert_equal method, result.method },
                   lambda { assert_equal line, result.line },
                 ]
    end

    param_test [
                 ["/path/a/b/c.rb", "labc", 3, "/path/a/b/c.rb:3:in `labc'"],
                 ["/path/a/b/c.rb", "labc", 3, "/path/a/b/c.rb:3:in `labc'"],
               ].each do |exppath, expmethod, expline, str|
      result = Frame.new entry: str
      assert_all [
                   lambda { assert_equal exppath, result.path },
                   lambda { assert_equal expmethod, result.method },
                   lambda { assert_equal expline, result.line },
                 ]
    end
  end
end
