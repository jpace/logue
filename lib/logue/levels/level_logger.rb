require 'logue/level'
require 'logue/core/object_util'

module Logue
  class LevelLogger
    attr_accessor :level

    def initialize level: Level::WARN
      @level = level
    end

    def verbose= v
      @level = case v
               when TrueClass
                 Level::DEBUG
               when FalseClass
                 Level::FATAL
               else
                 v
               end
    end

    def verbose
      @level <= Level::DEBUG
    end

    def quiet?
      @level >= Level::WARN
    end

    def quiet= b
      @level = b ? Level::WARN : Level::DEBUG
    end

    { :debug => Level::DEBUG, :info => Level::INFO, :warn => Level::WARN, :error => Level::ERROR, :fatal => Level::FATAL, :write => Level::WARN }.each do |methname, level|
      define_method methname do |msg = ObjectUtil::NONE, obj = nil, classname: nil, &blk|
        log msg, obj, level: level, classname: classname, &blk
      end
    end

    # Logs the given message.
    def log msg = ObjectUtil::NONE, obj = ObjectUtil::NONE, level: Level::DEBUG, classname: nil, &blk
      log_frames msg, obj, classname: classname, level: level, nframes: 0, &blk
    end

    # Writes the current stack, from where this method was invoked.
    def stack msg = ObjectUtil::NONE, obj = ObjectUtil::NONE, level: Level::DEBUG, classname: nil, &blk
      log_frames msg, obj, classname: classname, level: level, nframes: -1, &blk
    end

    def log_frames msg, obj = ObjectUtil::NONE, classname: nil, level: nil, nframes: -1, &blk
      raise "not implemented for LevelLogger"
    end
  end
end
