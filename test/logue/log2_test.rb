require 'logue/log'
require 'logue/log2'
require 'logue/logger'
require 'stringio'
require 'logue/tc'

module Logue
  class Log2Test < TestCase
    def test_complex
      basere = '^\[.../logue/log2_test.rb\s*:\s*\d+\] \{test_complex\s*\}'
      output = StringIO.new
      Log2.reset
      writer = Log.logger.writer
      writer.output = output
      Log.warn "mabc", %w{this is a test}
      re = Regexp.new basere + ' mabc.#: 4$'
      res = [re]
      %w{this is a test}.each_with_index do |value, index|
        re = Regexp.new basere + ' mabc\[' + index.to_s + '\]: ' + value + '$'
        res << re
      end
      output.flush
      lines = output.string.strip.split("\n").map(&:strip)
      assert_equal res.length, lines.length
      res.each_with_index do |re, index|
        line = lines[index]
        result = re.match line
        assert result, "index: #{index}; re: #{re}; line: #{line}???"
      end
    end
  end
end
