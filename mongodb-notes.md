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
