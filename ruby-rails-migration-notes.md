# Ruby Rails Migration Notes

## Create a table

```ruby
create_table :products do |t|
  t.string :name, null: false, default: ""
  t.timestamps
end
```

## Rename a field

```ruby
rename_column :users, :name, :title
```

## Add a column

```ruby
add_column :products, :part_number, :string
```

## Change fields on a table

```ruby
change_table :products do |t|
  t.change :price, :string
end
```

## Add index

```ruby
add_index :users, :identifier
```

## Change the null value for a column

```ruby
change_column_null :products, :name, false
```

## Change the default value for a column

```ruby
change_column_default :products, :approved, from: true, to: false
```

## Add timestamps from a table

```ruby
add_timestamps :widgets
```

## Remove timestamps from table

```ruby
remove_timestamps :widgets
```

## Drop a table

```ruby
drop_table :widgets
```

## Remove column

```ruby
remove_column :widgets, :price
```

## Run a query in a migration

```ruby
execute <<~SQL
  ALTER TABLE distributors
  ADD CONSTRAINT zipchk
  CHECK (char_length(zipcode) = 5);
SQL
```

## Output the amount of time for a block of migration code

```ruby
say_with_time "running widget update code" do
  # migration code
end
```

## Outputting a message during the migration

```ruby
say "here's a message" # not indented
say "part 1", true # indeneted
# -- here's a message
#    -> part 1
```

## Define the schema

```ruby
ActiveRecord::Schema.define do
  create_table :foos do |t|
    t.string :bar
  end
end
```
