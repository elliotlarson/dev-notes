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

### Inserting data

```bash
mongo> db.restaurants.insert(
   {
      "address" : {
         "street" : "2 Avenue",
         "zipcode" : "10075",
         "building" : "1480",
         "coord" : [ -73.9557413, 40.7720266 ]
      },
      "borough" : "Manhattan",
      "cuisine" : "Italian",
      "grades" : [
         {
            "date" : ISODate("2014-10-01T00:00:00Z"),
            "grade" : "A",
            "score" : 11
         },
         {
            "date" : ISODate("2014-01-16T00:00:00Z"),
            "grade" : "B",
            "score" : 17
         }
      ],
      "name" : "Vella",
      "restaurant_id" : "41704620"
   }
)
```
