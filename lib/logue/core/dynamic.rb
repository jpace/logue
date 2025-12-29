module Logue
  module Dynamic
    def add_color_method color, code
      add_class_method color do |msg = '', obj = nil, level = Level::DEBUG, &blk|
        colmsg = "\e[#{code}m#{msg}\e[0m"
        log colmsg, obj, level: level, &blk
      end
    end

    def add_class_method meth, &impl
      eigenclass = class << self; self; end
      eigenclass.class_eval do
        define_method meth, impl
      end
    end
  end
end
