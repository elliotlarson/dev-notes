# mongoDB Notes

## Installation

You can install with Homebrew:

```bash
$ brew update && brew install mongodb
```

To have it load on startup:

```bash
$ brew services start mongodb
```

## The mongo Shell

The mongo shell is an interactive JavaScript interface to MongoDB.

To start it, just type:

```bash
$ mongo
```

[Here is a shell quick reference](https://docs.mongodb.com/manual/reference/mongo-shell/)

### Listing databases

```bash
mongo> show dbs
```

### Creating a database

To create a new database, issue the `use` command:

```bash
mongo> use MyMovies
```

If you list the databases at this point, you won't see your new database in the list.  You need to add some data first.

### Listing collections

```bash
mongo> show collections
```

### Inserting data

```bash
mongo> db.movies.insert({ "name": "The Big Lebowski" })
```

### Return all documents in a collection

```bash
mongo> db.restaurants.find()
```

### Return documents filtered by a top level field

```bash
mongo> db.restaurants.find( { "borough": "Manhattan" } )
```

### Return documents filtered by a nested field

You can use the dot syntax to reference nested field filters:

```bash
mongo> db.restaurants.find( { "address.zipcode": "10075" } )
```

### Using comparison operators

You can also use [comparison operators](https://docs.mongodb.com/manual/reference/operator/query-comparison/) in your query as well.  This query uses the `$gt` greater than operator to find restaurants with a grade score of greater than 30:

```bash
mongo> db.restaurants.find( { "grades.score": { $gt: 30 } } )
```

### You can also use `or`

```bash
mongo> db.restaurants.find(
   { $or: [ { "cuisine": "Italian" }, { "address.zipcode": "10075" } ] }
)
```

### Updating

Update the first record that has the name "Juni", set the field "cuisine" to "American (New)" and update the "lastModified" field to the current date:

```bash
mongo> db.restaurants.update(
    { "name" : "Juni" },
    {
      $set: { "cuisine": "American (New)" },
      $currentDate: { "lastModified": true }
    }
)
```

You can update multiple records with:

```bash
mongo> db.restaurants.update(
  { "address.zipcode": "10016", cuisine: "Other" },
  {
    $set: { cuisine: "Category To Be Determined" },
    $currentDate: { "lastModified": true }
  },
  { multi: true}
)
```

You can also just replace the entire document:

```bash
mongo> db.restaurants.update(
   { "restaurant_id" : "41704620" },
   {
     "name" : "Vella 2",
     "address" : {
              "coord" : [ -73.9557413, 40.7720266 ],
              "building" : "1480",
              "street" : "2 Avenue",
              "zipcode" : "10075"
     }
   }
)
```

### Deleting data

You can remove all documents that match a condition:

```bash
mongo> db.restaurants.remove( { "borough": "Manhattan" } )
```

### Dropping a collection

```bash
mongo> db.restaurants.drop()
```

### Grouping

You can group by a specified field and count:

```bash
mongo> db.restaurants.aggregate(
   [
     { $group: { "_id": "$borough", "count": { $sum: 1 } } }
   ]
);
```
