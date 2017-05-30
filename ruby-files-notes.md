# Ruby File Notes

## CSV files

### Writing a CSV file

```ruby
CSV.open('path/to/file.csv') do |csv|
  csv << ['header 1', 'header 2']
  csv << ['data 1', 'data 2']
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