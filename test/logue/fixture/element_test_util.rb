require 'logue/elements/element'
require 'logue/elements/element_lines'
require 'logue/util/assertions'
require 'stringio'

module Logue
  module ElementTestUtil
    include Logue::Assertions

    def string_to_lines str
      lines = str.kind_of?(Array) ? str : str.split("\n")
      lines.map! { |it| it.kind_of?(Regexp) ? it : it.chomp }
      snip_at lines, 0
      snip_at lines, -1
      lines
    end

    def snip_at lines, index
      while lines[index] && lines[index].kind_of?(String) && lines[index].strip.empty?
        lines.delete_at index
      end
    end

    def run_write_test expected, &blk
      strio = StringIO.new
      lines = ElementLines.new strio, ""
      blk.call lines
      strio.close
      result = strio.string
      exp = string_to_lines expected
      res = string_to_lines result
      assert_lines exp, res
    end

    def compare_lines expected, actual
      exp = string_to_lines expected
      act = string_to_lines actual
      assert_lines exp, act
    end
  end
end

