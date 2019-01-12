# Ruby File Notes

## Text files

### Reading the whole file in at once

```ruby
fooness = File.read('foo.txt')
```

### Reading file lines as an array

```ruby
lines = File.readlines('foo.txt')
```

### Iterating through all lines in a file

```ruby
File.open('foo.txt') do |f|
  f.each_line do |line|
    # do some stuff with the line
  end
end
```

You could also get a file handle and then manually close it

```ruby
file = File.open('foo.txt')
file.each_line do |line|
  # do some stuff with the line
end
file.close
```

... or:

```ruby
File.open('foo.txt').each_line do |line|
  # do some stuff with the line
end
```

### Write to a file

```ruby
File.open('foo.txt', 'w') do |f|
  f.puts('some text')
end
```

This will overwrite the existing text in the file

To append to the existing text in the file

```ruby
File.open('foo.txt', 'a') do |f|
  f.puts('some text')
end
```

## CSV files

### Writing a CSV file

```ruby
CSV.open('path/to/file.csv', 'w') do |csv|
  csv << ['first_name', 'last_name', 'email']
  users.each do |user|
    csv << [user.first_name, user.last_name, user.email]
  end
end
```

### Writing CSV to a string

```ruby
my_csv = CSV.generate do |csv|
  csv << ['header 1', 'header 2']
  csv << ['data 1', 'data 2']
end
```

Shortcut approach:

```ruby
csv_string = ["CSV", "data"].to_csv
```

### Reading a CSV file

```ruby
CSV.foreach('path/to/file.csv') do |row|
  # row data in array form
end
```

Parsing with headers:

```ruby
CSV.foreach('path/to/file.csv', headers: true) do |row|
  # skips the first row
  # also allows access via hash form
  row #=> <CSV::Row "header 1":"data 1" "header 2":"data 2">
  row['header 1'] #=> 'data 1'
end
```

Say, you have a CSV string instead of a file for some reason:

```ruby
CSV_STRING = <<-CSV
header 1, header 2
data 1, data 2
CSV

CSV.parse(CSV_STRING, headers: true) do |row|
  row #=> <CSV::Row "header 1":"data 1" "header 2":"data 2">
end
```

You can also convert headers into symbols (spaces become underscores):

```ruby
CSV.parse(
  CSV_STRING,
  headers: true,
  header_converters: [:symbol]
) do |row|
  row #=> <CSV::Row header_1:"data 1" header_2:"data 2">
  row[:header_1] #=> 'data 1'
end
```

You can also downcase the headers:

```ruby
CSV_STRING = <<~EOF
  Header One,Header Two
  data 1,data 2
EOF

CSV.parse(
  CSV_STRING,
  headers: true,
  header_converters: [:symbol, :downcase]
) do |row|
  row[:header_one] #=> 'data 1'
end
```

If your CSV has blank rows:

```ruby
CSV_STRING = <<~EOF
  Header One,Header Two
  data 1a,data 1b

  data 2a,data 2b

EOF

CSV.parse(
  CSV_STRING,
  headers: true,
  header_converters: [:symbol, :downcase],
  skip_blanks: true,
) do |row|
  # only first and second data rows iterated over
end
```

### Reading tab delimited files

```ruby
CSV_STRING = <<~EOF
  Header One\tHeader Two
  data 1a\tdata 1b
  data 2a\tdata 2b
EOF

CSV.parse(
  CSV_STRING,
  headers: true,
  header_converters: [:symbol, :downcase],
  col_sep: "\t",
) do |row|
  binding.pry
end
```

### Iterating through files in a directory

Here's an example where we are looking to iterate over the svg images in a Rails directory:

```ruby
Dir.glob(Rails.root.join('app', 'views', 'fr', 'angle_and_spacings', 'panels', '*.svg')).each do |f|
  basename = File.basename(f)
  dirname = File.dirname(f)
  File.rename(f, "#{dirname}/_#{basename}.erb")
end
```
