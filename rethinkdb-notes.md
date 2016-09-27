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
