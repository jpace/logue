require 'logue/elements/elements_log'
require 'stringio'
require 'logue/tc'

module Logue
  class ElementsLog < TestCase
    def test_complex
      basere = '^\[.../elements_log_test.rb\s*:\s*\d+\] \{test_complex\s*\}'
      output = StringIO.new
      ElementsLog.reset
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
