require 'pathname'

module Logue
  class Frame
    FRAME_RE = Regexp.new '(.*):(\d+)(?::in \`(.*)\')?'

    attr_reader :path, :line, :method

    def initialize entry: nil, path: nil, line: nil, method: nil
      @path = path
      @line = line
      @method = method
    end

    def to_s
      [:path, :line, :method].collect { |field| "#{field}: " + send(field).to_s }.join ", "
    end
  end
end
