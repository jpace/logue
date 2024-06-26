loguelibdir = File.dirname __FILE__

$:.unshift(loguelibdir) unless
  $:.include?(loguelibdir) || $:.include?(File.expand_path(loguelibdir))

require 'pathname'

rbre = Regexp.new '\.rb$'

Pathname.glob(loguelibdir + '/logue/**/*.rb').each do |file|
  fname = file.to_s.sub(Regexp.new('^' + loguelibdir + '/'), '').sub(rbre, '')
  require fname
end
