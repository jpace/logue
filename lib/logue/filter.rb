require 'pathname'

module Logue
  class Filter
    attr_reader :files
    attr_reader :methods
    attr_reader :classes

    def initialize files: Array.new, methods: Array.new, classes: Array.new
      @files = files
      @methods = methods
      @classes = classes
    end

    def log? file, cls, meth
      !@files.include?(file) && !@classes.include?(cls) && !@methods.include?(meth)
    end
  end
end
