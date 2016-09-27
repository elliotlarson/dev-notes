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
$ rethinkdb -d ~/rethinkdb-data -n test-rethink-server
```

## ReQL 

You can execute `ReQL`, the query language for Rethinkdb, in the admin interface.  Navigate to http://localhost:8080 and click on the "Data Explorer" nav item.  This will put you on a page with an editor.

[Here is the documentation for ReQL](https://www.rethinkdb.com/api/javascript/)

### Creating a database

```javascript
r.dbCreate('ra-sam')
```

### Creating a table

```javascript
r.db('ra-sam').createTable('monthly-records')
```
