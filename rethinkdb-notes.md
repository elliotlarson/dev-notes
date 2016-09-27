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

Adding some data:

```javascript
r.db('ra_sam').table('monthly_records').insert({ end_of_month_date: '2012-01-31', production: 229.8036 })
r.db('ra_sam').table('monthly_records').count()
// 1
```

You can view the data with this:

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

This will allow you to update the document by chaining `update` onto the end:

```javascript
r.db('ra_sam').table('monthly_records').get('08a10125-6c8a-4710-9e0c-37dacd804034')
  .update({ production: 42.5 })
```


