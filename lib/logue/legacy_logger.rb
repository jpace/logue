require 'logue/filter'
require 'logue/format/location_format'

module Logue
  module LegacyLogger
    # this is deprecated and ignored:
    def trim= what
    end

    def ignore_file fname
      filter.files << fname
    end
    
    def ignore_method methname
      filter.methods << methname
    end
    
    def ignore_class classname
      filter.classes << classname
    end

    def log_file fname
      filter.files.delete fname
    end
    
    def log_method methname
      filter.methods.delete methname
    end
    
    def log_class classname
      filter.classes.delete classname
    end

    def output
      writer.output
    end

    def output= obj
      writer.output = obj
    end

    def colorize_line
      writer.colorize_line
    end

    def colorize_line= b
      writer.colorize_line = b
    end

    def set_default_widths
      self.format = LocationFormat.new
    end
    
    def set_color lvl, color
      writer.colors[lvl] = color
    end
  end
end
