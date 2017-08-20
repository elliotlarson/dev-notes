# Ruby Profiling Notes

## Profiling with RubyProf

### Printing output with the flat printer

This will print the simplest output, suitable for standard out

```ruby
require 'ruby-prof'

FooBar = Struct.new(:foo, :bar) do
  def foobar
    [foo, slow_bar].join
  end

  def slow_bar
    sleep 1
    bar
  end
end

result = RubyProf.profile do
  10.times do
    fb = FooBar.new('yo', 'yo')
    fb.foobar
  end
end

printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
```

```text
Measure Mode: wall_time
Thread ID: 70289765693380
Fiber ID: 70289766167740
Total: 10.036045
Sort by: self_time

 %self      total      self      wait     child     calls  name
 99.99     10.035    10.035     0.000     0.000       10   Kernel#sleep
  0.00     10.036     0.000     0.000    10.036       10   FooBar#foobar
  0.00      0.000     0.000     0.000     0.000       10   Array#join
  0.00     10.036     0.000     0.000    10.035       10   FooBar#slow_bar
  0.00      0.000     0.000     0.000     0.000       10   FooBar#bar
  0.00     10.036     0.000     0.000    10.036        1   Integer#times
  0.00      0.000     0.000     0.000     0.000       10   <Class::FooBar>#new
  0.00     10.036     0.000     0.000    10.036        1   Global#[No method]
  0.00      0.000     0.000     0.000     0.000       10   Struct#initialize
  0.00      0.000     0.000     0.000     0.000       10   FooBar#foo

* indicates recursively called methods
```

### Flat printer with line numbers

This format is supposed to be the same as flat printer with more info, but it seems like it's more informative

```ruby
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
```

```text
Measure Mode: wall_time
Thread ID: 70302390548420
Fiber ID: 70302391018140
Total: 1.213355
Sort by: self_time

 %self      total      self      wait     child     calls  name
 99.50      1.207     1.207     0.000     0.000      100   Kernel#sleep
      called from:
          FooBar#slow_bar (/Users/Elliot/Learning/Ruby/profiling/ruby-prof-test.rb:8)

  0.13      0.002     0.002     0.000     0.000      100   Array#join
      called from:
          FooBar#foobar (/Users/Elliot/Learning/Ruby/profiling/ruby-prof-test.rb:4)

  0.09      1.209     0.001     0.000     1.208      100   FooBar#slow_bar
      defined at:
          /Users/Elliot/Learning/Ruby/profiling/ruby-prof-test.rb:8
      called from:
          FooBar#foobar (/Users/Elliot/Learning/Ruby/profiling/ruby-prof-test.rb:4)

  0.09      1.213     0.001     0.000     1.212        1   Integer#times
      called from:
          Global#[No method] (/Users/Elliot/Learning/Ruby/profiling/ruby-prof-test.rb:15)

  0.07      0.001     0.001     0.000     0.000      100   <Class::FooBar>#new

  0.06      1.211     0.001     0.000     1.210      100   FooBar#foobar
      defined at:
          /Users/Elliot/Learning/Ruby/profiling/ruby-prof-test.rb:4

  0.03      0.000     0.000     0.000     0.000      100   FooBar#bar
      called from:
          FooBar#slow_bar (/Users/Elliot/Learning/Ruby/profiling/ruby-prof-test.rb:8)

  0.02      0.000     0.000     0.000     0.000      100   Struct#initialize

  0.01      0.000     0.000     0.000     0.000      100   FooBar#foo
      called from:
          FooBar#foobar (/Users/Elliot/Learning/Ruby/profiling/ruby-prof-test.rb:4)

  0.00      1.213     0.000     0.000     1.213        1   Global#[No method]
      defined at:
          /Users/Elliot/Learning/Ruby/profiling/ruby-prof-test.rb:15


* indicates recursively called methods
```

### Printing output with the callstack printer

This will print an HTML page with an interactive hierarchical call stack

```ruby
require 'ruby-prof'

FooBar = Struct.new(:foo, :bar) do
  def foobar
    [foo, slow_bar].join
  end

  def slow_bar
    sleep 1
    bar
  end
end

result = RubyProf.profile do
  10.times do
    fb = FooBar.new('yo', 'yo')
    fb.foobar
  end
end

printer = RubyProf::CallStackPrinter.new(result)
File.open('prof.out.html', 'w') do |f|
  printer.print(f)
end
```

[CallStackPrinter](img/ruby-call-stack-prof.png)

## Profiling with StackProf

Here you can get arguably clearer output about what is taking the most time in your code.

First you generate a dump file with raw data about your code run. Then stackprof comes with a command line app that will process the output.

This will dump output to a dump file

```ruby
require 'stackprof'

FooBar = Struct.new(:foo, :bar) do
  def foobar
    [foo, slow_bar].join
  end

  def slow_bar
    sleep 0.1
    bar
  end
end

StackProf.run(mode: :wall, out: 'stackprof-wall.dump') do
  100.times do
    fb = FooBar.new('yo', 'yo')
    fb.foobar
  end
end
```

### Plain text output

```bash
$ stackprof stackprof-wall.dump --text
```

```text
==================================
  Mode: wall(1000)
  Samples: 10015 (0.00% miss rate)
  GC: 0 (0.00%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
     10015 (100.0%)       10015 (100.0%)     FooBar#slow_bar
     10015 (100.0%)           0   (0.0%)     FooBar#foobar
     10015 (100.0%)           0   (0.0%)     block (2 levels) in <main>
     10015 (100.0%)           0   (0.0%)     block in <main>
     10015 (100.0%)           0   (0.0%)     <main>
     10015 (100.0%)           0   (0.0%)     <main>
```
