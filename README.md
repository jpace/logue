logue
=====

A Ruby gem for generating logging and debugging output. Logging statements include the file, line,
class and method from which the logging method was called.

## EXAMPLES

```
require 'logue/log'
require 'logue/loggable'

Logue::Log.level = Logue::Log::DEBUG

class MyClass
  include Logue::Loggable

  def mymethod foo
    info "foo: #{foo}"
  end
end

obj = MyClass.new
obj.mymethod "bar"
```

Produces:

```
[/tmp/foo.rb              :  13] {MyClass#mymethod    } foo: bar
```
