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
