# PG Search Notes

https://github.com/Casecommons/pg_search

There are two kinds of PG search, single model search and global multi-model search, which is a global search across multiple models in your system.

## Questions?

* Is there a way to do multi-model search with different groups of models, like one group of models for a section of the site, and another group of models for another section of a site?

## Single Model Search

You can add a search scope to your model, like so:

```ruby
class Person < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_by_full_name, against: [:first_name, :last_name]
end
```

This will allow somewhat natural language searching with Postgres's full text search capabilities.

```ruby
person_1 = Person.create!(first_name: "Grant", last_name: "Hill")
person_2 = Person.create!(first_name: "Hugh", last_name: "Grant")

Person.search_by_full_name("Grant") # => [person_1, person_2]
Person.search_by_full_name("Grant Hill") # => [person_1]
```

## Multi Model Global Search

To use multi search you need to do some setup:

```bash
$ rails g pg_search:migration:multisearch
$ rake db:migrate
```

This will create a table for the index of combined data from the multi searchable models.

```ruby
class EpicPoem < ActiveRecord::Base
  include PgSearch::Model
  multisearchable against: [:title, :author]
end

class Flower < ActiveRecord::Base
  include PgSearch::Model
  multisearchable against: :color
end
```

### Searching

Then you can search on both model types with one search:

```ruby
odyssey = EpicPoem.create!(title: "Odyssey", author: "Homer")
rose = Flower.create!(color: "Red")
PgSearch.multisearch("Homer") #=> [#<PgSearch::Document searchable: odyssey>]
PgSearch.multisearch("Red") #=> [#<PgSearch::Document searchable: rose>]
```

### How This Works

When you create, update, or delete a record with `multisearch` applied to the model pg_search will automatically create a record in the `pg_search_documents` table.  The combined value of text that you want to be searched will be added to the `content` field.

Two associations are built automatically. On the original record, there is a has_one :pg_search_document association pointing to the PgSearch::Document record, and on the PgSearch::Document record there is a belongs_to :searchable polymorphic association pointing back to the original record.

```ruby
odyssey = EpicPoem.create!(title: "Odyssey", author: "Homer")
search_document = odyssey.pg_search_document #=> PgSearch::Document instance
search_document.searchable #=> #<EpicPoem id: 1, title: "Odyssey", author: "Homer">
```

### Only Searching a Subset of Models

```ruby
PgSearch.multisearch("Red").where(search_type: [Flower])
```

### Remove Search Documents For a Model

```ruby
PgSearch::Document.delete_by(searchable_type: "Flower")
```

### To Regenerate Documents For a Model

```ruby
PgSearch::Multisearch.rebuild(Flower)
```

There is a rake task for this:

```bash
$ rake 'pg_search:multisearch:rebuild[Flower]'
```
