# Association Notes

## Polymorphic associations

Belonging to more than one model on a single association.

```ruby
class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
end

class Person < ApplicationRecord
  has_many :addresses, as: :addressable
end

class Company < ApplicationRecord
  has_many :addresses, as: :addressable
end
```

You can create the address migration like this:

```ruby
create_table :addresses do |t|
  t.string :street
  t.string :line2
  t.string :city
  t.string :state
  t.string :zip
  t.bigint :addressable_id
  t.string :addressable_type
  t.timestamps
end

add_index :addresses, %i[addressable_id addressable_type]
```

... or, with `references`:

```ruby
create_table :addresses do |t|
  t.string :street
  t.string :line2
  t.string :city
  t.string :state
  t.string :zip
  t.references :addressable, polymorphic: true
  t.timestamps
end
```

You can generate this migration with:

```bash
$ rails g migration create_addresses street:string line2:string city:string state:string zip:string addressable:references{polymorphic}
```

Another example would be comments:

```ruby
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
end

class BlogPost < ApplicationRecord
  has_many :comments, as: :commentable
end

class NewsItem < ApplicationRecord
  has_many :comments, as: :commentable
end
```
