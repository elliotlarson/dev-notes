# Rethinkdb Notes

## Installation

You can use Homebrew to install rethinkdb:

```bash
$ brew update && brew install rethinkdb
```

## Starting the server

This will start the server and run the admin console on `http://localhost:8080`:

```bash
$ rethinkdb
```

To see the options available to you, you can issue this command with the `--help` flag:

```bash
$ rethinkdb --help
```

Here's a command where you specify the directory and server name:

```bash
$ rethinkdb -d ~/rethinkdb_data -n test_rethink_server
```

## Starting on boot

[Information about setting up to start on boot](/Library/LaunchDaemons/com.rethinkdb.server.plist)

## ReQL 

You can execute `ReQL`, the query language for Rethinkdb, in the admin interface.  Navigate to http://localhost:8080 and click on the "Data Explorer" nav item.  This will put you on a page with an editor.

[Here is the documentation for ReQL](https://www.rethinkdb.com/api/javascript/)

### Creating, listing, and dropping database

```javascript
r.dbCreate('ra_sam')
r.dbList()
// [
//   "ra_sam" ,
//   "rethinkdb" ,
//   "test"
// ]
r.dbDrop('ra_sam')
r.dbList()
// [
//   "rethinkdb" ,
//   "test"
// ]
```

### Creating, listing, and dropping a table

```javascript
r.db('ra_sam').tableCreate('monthly_records')
r.db('ra_sam').tableList()
// [
//   "monthly_records"
// ]
r.db('ra_sam').tableDrop('monthly_records')
r.db('ra_sam').tableList()
// [ ]
```

### CRUD

#### Creating 

```javascript
r.db('ra_sam').table('monthly_records').insert(
  { 
    monthly_recordable_id: 2, 
    monthly_recordable_type: 'Forecast', 
    end_of_month_date: '2012-01-31', 
    production: 229.8036, 
  }
)
r.db('ra_sam').table('monthly_records').count()
// 1
```

#### Reading

This will return all data:

```javascript
r.db('ra_sam').table('monthly_records')
```

You can retrieve data that matches criteria with the `filter` command:

```javascript
r.db('ra_sam').table('monthly_records').filter({ end_of_month_date: '2012-01-31' })
```

You can get a specific document with the `get` command, using the guid for the document:

```javascript
r.db('ra_sam').table('monthly_records').get('08a10125-6c8a-4710-9e0c-37dacd804034')
```

#### Updating

```javascript
r.db('ra_sam').table('monthly_records').get('08a10125-6c8a-4710-9e0c-37dacd804034')
  .update({ production: 42.5 })
```

#### Deleting

```javascript
r.db('ra_sam').table('monthly_records').get('08a10125-6c8a-4710-9e0c-37dacd804034')
  .delete()
```

### More advanced reading/filtering

You can use regular expressions:

```javascript
r.db('bookmarks').table('bookmarks').filter(
  function(bookmark) { 
    return bookmark('title').match('.* [gG]o(lang)* *.');
  }
)
```

Say you have a nested array like tags.  You can filter on these like this:

```javascript
r.db('bookmarks').table('bookmarks').filter(
  function(bookmark) { 
    return bookmark('tags').contains('golang');
  }
)
```

### Common functions

* [pluck](https://www.rethinkdb.com/api/ruby/pluck/)
* [filter](https://www.rethinkdb.com/api/ruby/filter/)
* [concatMap](https://www.rethinkdb.com/api/ruby/concat_map/)
* [map](https://www.rethinkdb.com/api/ruby/map/)
* [hasFields](https://www.rethinkdb.com/api/ruby/has_fields/)
* [withFields](https://www.rethinkdb.com/api/ruby/with_fields/)
* [limit](https://www.rethinkdb.com/api/ruby/limit/)
* [orderBy](https://www.rethinkdb.com/api/ruby/order_by/)
* [skip](https://www.rethinkdb.com/api/ruby/skip/)

## Importing data

You can import JSON or CSV data.

### Importing a JSON file

Lets create a `bookmarks` database with a single `bookmarks` table:

```javascript
r.dbCreate('bookmarks')
r.db('bookmarks').tableCreate('bookmarks')
```

Assume we have a file with bookmarks JSON data `bookmarks.json`:

```json
[
  {
    "url": "https://medium.com/@matryer/golang-advent-calendar-day-seventeen-io-reader-in-depth-6f744bb4320b#.x4ucxwf6e",
    "title": "io.Reader in depth — Medium",
    "tags": ["golang", "interfaces", "reader"]
  },
  {
    "url": "http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api",
    "title": "Best Practices for Designing a Pragmatic RESTful API | Vinay Sahni",
    "tags": ["api", "rest", "best-practices"]
  },
]
```

We can import this like so:

```bash
$ rethinkdb import -f bookmarks.json --table bookmarks.bookmarks --format json --force
```

You need the `--force` command to load into an existing table.

**Note**: The import tool is a python script.  You will need to have the Python driver installed:

```bash
$ sudo pip install rethinkdb
```

