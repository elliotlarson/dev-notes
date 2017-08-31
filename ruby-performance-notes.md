# Ruby Performance Notes

Notes pulled from [Ruby Performance Optimization](https://pragprog.com/book/adrpo/ruby-performance-optimization) book

## GC Is Expensive

Lets take some versions of Ruby and run some benchmarks with it:

* 1.9.3-p448
* 2.0.0-p648
* 2.1.2
* 2.2.1
* 2.3.3
* 2.4.1

Then this benchmark script

```ruby
require 'benchmark'

num_rows = 100_000
num_cols = 10

data = Array.new(num_rows) do
  Array.new(num_cols) { 'x' * 1_000 }
end

time = Benchmark.realtime do
  csv = data.map { |row| row.join(',') }.join("\n")
end

puts time.round(2)
```

And, lets run this bash script to execute this script for the ruby versions (using rbenv):

```bash
$ for version in 1.9.3-p448 2.0.0-p648 2.1.2 2.2.1 2.3.3 2.4.1; do rbenv shell $version; echo $version: $(ruby test.rb); done
```

The output for my laptop looked like:

```text
1.9.3-p448: 4.27
2.0.0-p648: 6.77
2.1.2: 2.46
2.2.1: 1.62
2.3.3: 1.5
2.4.1: 1.6
```

Now lets run an example with garbage collection turned off:

```ruby
require 'benchmark'

num_rows = 100_000
num_cols = 10

data = Array.new(num_rows) do
  Array.new(num_cols) { 'x' * 1_000 }
end

GC.disable

time = Benchmark.realtime do
  csv = data.map { |row| row.join(',') }.join("\n")
end

puts time.round(2)
```

The output now is:

```text
1.9.3-p448: 0.93
2.0.0-p648: 0.92
2.1.2: 0.96
2.2.1: 0.97
2.3.3: 0.93
2.4.1: 0.99
```

Notice that all of the Ruby versions are roughly similar now in terms of execution time.  There was a new virtual machine introduced in Ruby 1.9. Beyond that, almost all performance improvements to Ruby since have been around garbage collection.

## Memory consumption and GC are among the top reasons Ruby is slow

High memory consumption makes Ruby slow.  To optimize we need to reduce the memory footprint, which will in turn reduce the time spent in GC.

Lets look at the memory consumption of the Ruby proess

```ruby
require 'benchmark'

num_rows = 100_000
num_cols = 10

data = Array.new(num_rows) do
  Array.new(num_cols) do
    'x' * 1_000
  end
end

before = "Before = %d MB" % (`ps -o rss= -p #{Process.pid}`.to_i / 1024)

GC.disable

time = Benchmark.realtime do
  csv = data.map { |row| row.join(',') }.join("\n")
end

after = "After = %d MB" % (`ps -o rss= -p #{Process.pid}`.to_i / 1024)

puts([before, after].join(', '))
```

We can run this the same way as before, and we get results like:

```text
1.9.3-p448: Before = 1033 MB, After = 2976 MB
2.0.0-p648: Before = 1052 MB, After = 2992 MB
2.1.2: Before = 1045 MB, After = 2986 MB
2.2.1: Before = 1047 MB, After = 2985 MB
2.3.3: Before = 1046 MB, After = 2986 MB
2.4.1: Before = 1045 MB, After = 2986 MB
```

You can see our data takes up about 1 GB, but our code uses roughly 2 more GB.

In the implementation of our script we are copying the data into an intermediary state with `map` before we join the lines with `\n`.

We can solve this problem by refactoring:

```ruby
require 'benchmark'

num_rows = 100_000
num_cols = 10

data = Array.new(num_rows) do
  Array.new(num_cols) do
    'x' * 1_000
  end
end

time = Benchmark.realtime do
  csv = ''
  num_rows.times do |i|
    num_cols.times do |j|
      csv << data[i][j]
      csv << ',' unless j == num_cols - 1
    end
    csv << "\n" unless i == num_rows - 1
  end
end

puts time.round(2)
```

The results of this, event with GC turned back on, is:

```text
1.9.3-p448: 0.82
2.0.0-p648: 0.83
2.1.2: 0.78
2.2.1: 0.82
2.3.3: 0.71
2.4.1: 0.77
```
