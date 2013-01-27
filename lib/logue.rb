loguelibdir = File.dirname(__FILE__)

$:.unshift(loguelibdir) unless
  $:.include?(loguelibdir) || $:.include?(File.expand_path(loguelibdir))

module Logue
  VERSION = '1.1.17'
end
