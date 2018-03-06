#!/usr/bin/ruby -w
# -*- ruby -*-

require 'pathname'

module Logue
  class Filter
    include Comparable
    
    attr_reader :ignored_files
    attr_reader :ignored_methods
    attr_reader :ignored_classes

    def initialize ignored_files: Array.new, ignored_methods: Array.new, ignored_classes: Array.new
      @ignored_files   = ignored_files
      @ignored_methods = ignored_methods
      @ignored_classes = ignored_classes
    end

    def ignore_file file
      @ignored_files << file
    end

    def log_file file
      @ignored_files.delete file
    end      

    def ignore_class cls
      @ignored_classes << cls
    end

    def log_class cls
      @ignored_classes.delete cls
    end      

    def ignore_method meth
      @ignored_methods << meth
    end

    def log_method meth
      @ignored_methods.delete meth
    end

    def log? file, cls, meth
      !@ignored_files.include?(file) && !@ignored_classes.include?(cls) && !@ignored_methods.include?(meth)
    end

    def compare_fields
       [ :ignored_files, :ignored_methods, :ignored_classes ]
    end

    def <=> other
      compare_fields.each do |field|
        cmp = send(field) <=> other.send(field)
        return cmp if cmp.nonzero?
      end
      0
    end
  end
end
