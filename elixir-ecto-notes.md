# Elixir Ecto Queries Notes

## Aliases and imports

These examples are using aliases, for example:

```elixir
alias MyApp.Repo
alias MyApp.Product
```

... so now we can refer to `Product` directly.

Also, the `from` macro is usable because we've imported it, like so:

```elixir
import Ecto.Query
```

## Get all records

```elixir
Repo.all(ProductCategory)
# SELECT
#   p0."id",
#   p0."name"
# FROM
#  "product_categories" AS p0
```

## Get last record

```elixir
Repo.one(from(p in Product, order_by: [desc: p.inserted_at], limit: 1))
# SELECT
#   p0."id",
#   p0."name",
#   p0."inserted_at"
# FROM
#   "products" AS p0
# ORDER BY
#   p0."inserted_at" DESC
# LIMIT 1
```

## Get records with multiple search criteria

You can use two different kinds of syntaxes for this.  First:

```elixir
from p in Product,
where: p.active == true and p.number_in_stock > 0
|> Repo.all
# SELECT
#   p0."id",
#   p0."name",
#   p0."number_in_stock",
#   p0."active"
# FROM
#   "products" AS p0
# WHERE
#   (
#     (p0."active" = TRUE)
#   AND
#     (p0."number_in_stock" > 0)
#   )
```

...or you can use this:

```elixir
Product
|> where([p], p.active == true and p.number_in_stock > 0)
|> Repo.all
```

## Get one record

Get the record by id:

```elixir
Repo.get(Product, 1)
# SELECT
#   p0."id",
#   p0."name"
# FROM
#   "products" AS p0
# WHERE
#   (p0."id" = $1)
```

Get the record by a value:

```elixir
Repo.get_by(ProductCategory, name: "Shared Care")
# SELECT
#   p0."id",
#   p0."name"
# FROM
#   "product_categories" AS p0
# WHERE
#   (p0."name" = $1)
```

## Get records where field equals some value

```elixir
Repo.all(from(p in Product, where: p.product_type_id == 1))
```

If you're doing this inside of a module method, you can pass in the
`product_type_id` like so:

```elixir
def for_product_type(query, product_type_id) do
  query |> where([p], p.product_type_id == ^product_type_id)
end
```

Then you can use the returned query like so:

```elixir
Product.for_product_type(1) |> Repo.all
```

## Getting records with like

There are two kinds of like: `like` which is case sensitive and `ilike` which is case insensitive.

```elixir
from(p in Product, where: ilike(p.name, "%Clinical Trial%")) |> Repo.all
# SELECT
#   p0."id",
#   p0."name"
# FROM
#   "products" AS p0
# WHERE
#   (p0."name" ILIKE '%Clinical Trial%')
```

[Query API methods documentation](https://hexdocs.pm/ecto/Ecto.Query.API.html#ilike/2).

## Getting records with values "in" list:

```elixir
Repo.all(from p in Product, where: p.id in [9, 10, 14])
# SELECT
#   p0."id",
#   p0."name"
# FROM
#   "products" AS p0
# WHERE
#   (p0."id" IN (9,10,14))
```

## Getting records inserted in last month

Right now there is no datetime_sub method, so we have to use `datetime_add`:

```elixir
Repo.all(
  from p in Product,
  where: p.inserted_at < datetime_add(^Ecto.DateTime.utc, -1, "month")
)
# SELECT
#   p0."id",
#   p0."name",
#   p0."inserted_at"
# FROM
#   "products" AS p0
# WHERE
#   (p0."inserted_at" > ($1::timestamp + (-1::numeric * interval '1 month'))::timestamp)
```

## Composing queries

See this [StackOverflow answer from Jose Valim](http://stackoverflow.com/questions/32282678/how-to-access-current-module-in-elixir), and this article about creating [composable queries](http://blog.drewolson.org/composable-queries-ecto/).

Continuing with the previous example, lets say in addition to our `for_product_type` query method, we also had a `recent` method:

```elixir
def recent(query, number \\ 10) do
  from p in query,
  order_by: [desc: p.inserted_at],
  limit: ^number
end
```

... then you could string these together like so:

```elixir
Product
|> Product.for_product_type(1)
|> Product.recent(15)
|> Repo.all
```

## Pluck a field

Similar to the Rails `ProductCategory.all.pluck(:name)`.

```elixir
Repo.all(from(c in ProductCategory, select: c.name))
# SELECT p0."name" FROM "product_categories" AS p0
```

## Get a collection of ids and names

Similar to Rails `ProductCategory.select(:id, :name).all.map { |pc| [pc.id, pc.name] }`.

```elixir
Repo.all(from(c in ProductCategory, select: [c.id, c.name]))
# SELECT p0."id", p0."name" FROM "product_categories" AS p0
```

## Counting records

Adds count to the query. Similar to `User.count` in Rails.

```elixir
Repo.one(from(u in User, select: count(u.id)))
# SELECT count(u0."id") FROM "users" AS u0
```

Pulls back a complete resultset and then counts the resulting list.  Similar to `User.all.size` in Rails.

```elixir
Repo.all(User) |> Enum.count
# SELECT u0."id", u0."first_name", u0."last_name" FROM "users" AS u0
```

## Pulling in related data

You can do this with the `assoc` method, which assumes you have a belongs_to or has_many association setup:

Here we grab a `belongs_to` association:

```elixir
product = Repo.get(Product, 9)
# SELECT p0."id", p0."name", p0."product_type_id" FROM "products" AS p0 WHERE (p0."id" = $1)
product_type = Ecto.Model.assoc(product, :type) |> Repo.one
# SELECT p0."id", p0."name" FROM "product_types" AS p0 WHERE (p0."id" IN ($1))
```

Here we grab a `has_many` association:

```elixir
product_type = Repo.get(ProductType, 1)
# SELECT p0."id", p0."name" FROM "product_types" AS p0 WHERE (p0."id" = $1)
products = Ecto.Model.assoc(product_type, :products) |> Repo.all
# SELECT p0."id", p0."name", p0."product_type_id" FROM "products" AS p0 WHERE (p0."product_type_id" IN ($1))
```

You can also preload associated data, like so:

```elixir
[first_product | products] = Repo.all(from p in Product, preload: [:type])
# SELECT p0."id", p0."name" p0."product_type_id" FROM "products" AS p0
# SELECT p0."id", p0."name" FROM "product_types" AS p0 WHERE (p0."id" IN ($1))
first_product.type
```

This pulls back the product data and it exectutes a second query to pull back related product type data.

If you want the results to be returned as a part of a single query, you can do it like this:

```elixir
Repo.all(
  from p in Product,
  join: t in assoc(p, :type),
  select: {p, t}
)
# SELECT
#   p0."id",
#   p0."name",
#   p0."product_type_id",
#   p1."id",
#   p1."name"
# FROM
#   "products" AS p0
#   INNER JOIN "product_types" AS p1
#   ON p1."id" = p0."product_type_id"
```

## Executing raw SQL query

```elixir
Ecto.Adapters.SQL.query(Repo, "SELECT power($1, $2)", [2, 10])
```
