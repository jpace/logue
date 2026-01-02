require 'logue/elements/element'
require 'logue/elements/element_lines'
require 'stringio'

module Logue
  module ElementTestUtil
    def string_to_lines str
      lines = str.split("\n").map(&:chomp)
      while lines[0] && lines[0].strip.empty?
        lines.delete_at 0
      end
      while lines[-1] && lines[-1].strip.empty?
        lines.delete_at -1
      end
      lines
    end

    def run_write_test expected, &blk
      strio = StringIO.new
      lines = ElementLines.new strio
      blk.call lines
      strio.close
      result = strio.string
      exp = string_to_lines expected
      res = string_to_lines result
      assert_equal exp, res
    end
  end
end

