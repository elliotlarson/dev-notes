# Docker Postgres Notes

## Running a legacy version of Postgres

Here I'm running the most recent version of Postgres 10x in detached mode on port 5555, storing the data files in the current directory.

```bash
$ docker run --rm --name pg-10 -e POSTGRES_PASSWORD=supersecret -d -p 5555:5432 -v $(pwd):/var/lib/postgresql/data postgres:10
```

Then login into the database with:

```bash
$ psql -h 127.0.0.1 -p 5555 -U postgres -d postgres
```

## Creating and deleting a database

Create the database:

```bash
$ psql -h 127.0.0.1 -p 5555 -U postgres -d postgres -c "CREATE DATABASE mydb"
```

See if it got created:

```bash
$ psql -h 127.0.0.1 -p 5555 -U postgres -d postgres -c "SELECT datname FROM pg_database"
```

Delete the database:

```bash
$ psql -h 127.0.0.1 -p 5555 -U postgres -d postgres -c "DROP DATABASE mydb"
```

## Load a PG database dump into it

Restore from a postgres compressed dump file:

```bash
$ pg_restore -C -e -O -x -v -Fc -h 127.0.0.1 -p 5555 -U postgres -j 4 <mydumpfile>
```
