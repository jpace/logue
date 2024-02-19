require 'pathname'

module Logue
  class Frame
    FRAME_RE = Regexp.new '(.*):(\d+)(?::in \`(.*)\')?'

    attr_reader :path, :line, :method

    def initialize entry: nil, path: nil, line: nil, method: nil
      # entry if called from "caller(x)" elements, path/line/method if called from
      # "caller_location(x)" elements.
      if entry
        md = FRAME_RE.match entry
        @path = md[1]
        @line = md[2].to_i
        @method = md[3] || ""
      else
        @path = path
        @line = line
        @method = method
      end
    end

    def to_s
      [:path, :line, :method].collect { |field| "#{field}: " + send(field).to_s }.join ", "
    end
  end
end
