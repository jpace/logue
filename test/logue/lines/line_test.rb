require 'logue/lines/line'
require 'logue/tc'

class Logue::LineTest < Logue::TestCase
  include Logue

  def self.build_line_params
    Array.new.tap do |a|
      a << ["s1", "s1"]
      a << ["s1: o2", "s1", "o2"]
      a << ["s1: [0, 1, 2, 3]", "s1", (0..3).to_a]
    end
  end

  param_test build_line_params do |expmsg, msg, obj = nil|
    line = Line.new msg, obj
    result = line.message_string
    assert_equal expmsg, result
  end
end

class Logue::LineBlockTest < Logue::TestCase
  include Logue

  def test_block
    arg = Proc.new { "arg is: xyz" }
    obj = LineBlock.new arg
    result = obj.message_string
    assert_equal "arg is: xyz", result
  end
end
