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

... or

```ruby
File.foreach('foo.txt') do |line|
  # do some stuff with the line
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

### Stripping fields with a custom converter

```ruby
# You can register the converter for CSV like so and then use it
CSV::Converters[:strip_fields] = ->(f) { f&.strip }
# Then you can use it like so
CSV.foreach(csv_file, converters: [:strip_fields] ) do |row|
  # row processing code
end
```

Also, instead of registering it and accessing it with a key, you can pass in a lambda instead of a key name:

```ruby
strip_fields = ->(f) { f&.strip }
# Then you can use it like so
CSV.foreach(csv_file, converters: [strip_fields] ) do |row|
  # row processing code
end
```

### Custom converters by header name

You can also pass in a converter that will handle fields on a header name basis:

https://stackoverflow.com/a/51233900/2325596

```ruby
custom_converter = lambda do |value, field_info|
  case field_info.header
  when 'OrderUuid', 'Exchange', 'Type', 'OrderType'
    value.to_s
  when 'Quantity', 'Limit', 'CommissionPaid', 'Price'
    value.to_f
  when 'Opened', 'Closed'
    Time.zone.parse(value)
  else
    fail("Unknown field name #{field_info.inspect}=#{value}")
  end
end

CSV.parse(content, headers: :first_row, converters: [custom_converter])
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

### Read the first line of a file

```ruby
first_line = File.open('file.txt', &:readline)
```

### Get the current directory of a file

For the relative path:

```ruby
dir = __dir__
```

For the absolute path:

```ruby
dir = File.expand_path(__dir__)
```

You can also get at this information with:

```ruby
dir = File.expand_path(File.dirname(__FILE__))
```

### Iterate through a directory listing using glob

You can get all of the files and directories in the current directory with:

```ruby
Dir.glob("*")
```

This will only give you the current level.  To recurse, use this:

```ruby
Dir.glob("**/*")
```

If you are not in the correct directory, you can change into this directory with:

```ruby
Dir.chdir("/some/other/dir") do
  Dir.glob("*")
end
```

Glob will give you everything including "." and "..".  Let's say you only want the directories in the current directory:

```ruby
Dir.glob("*").each do |f|
  if File.directory?(f)
    # do some stuff
  end
end
```

You can also grab stuff that matches a regex:

```ruby
Dir.glob("*").each do |f|
  if f.match?(/^\d{3})
    # do some stuff
  end
end
```

## Create a directory

If the directory does not exist

```ruby
Dir.mkdir("dir") unless File.directory?("dir")
```

... or you can use FileUtils

```ruby
require "fileutils"

FileUtils.mkdir_p("dir")
```

## Load a YAML file

```ruby
YAML.load_file("path/to/file.yml")
```

## Load a YAML string

```ruby
yaml_string = <<~YAML
en:
  activerecord:
    attributes:
      order:
        inv_num: "Invoice number"
YAML
YAML.load(yaml_string)
```

## Load an ERB YAML file

```ruby
YAML.load(ERB.new(File.read("path/to/file.yml")).result)
```

## Load a JSON file

```ruby
JSON.parse(File.read("path/to/file.yml"))
```
