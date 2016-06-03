# Golang SQL Notes

Using the `sql` package to interact with a database (Postgres in our case).

## Setting up the database

Lets create a quick Postgres database user:

```bash
$ createuser -P -d gosql_user
```

Enter in the password `secret` when prompted.

Now create a database owned by the `gosql_user`.

```bash
$ createdb -O gosql_user gosql
```

Create an SQL file for a table `players_table.sql`:

```sql
CREATE TABLE players (
	id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	team varchar(100),
	number integer,
	created_at timestamp without time zone,
	updated_at timestamp without time zone
);
```

Then load the table into the `gosql` database:

```bash
$ psql -U gosql_user -f players_table.sql -d gosql
```

## Creating a record

Here we'll use the `sql.QueryRow` approach to insert the record and then return the `id`, `created_at`, and `updated_at` values of the newly created record.

```go
import (
	"database/sql"

	_ "github.com/lib/pq"
)

type player struct {
	ID        int
	FirstName string
	LastName  string
	Team      string
	Number    int
	CreatedAt time.Time
	UpdatedAt time.Time
}

func (p *player) Create() (err error) {
	sql := `
		INSERT INTO players (
			first_name, last_name, team, number, created_at, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6)
		RETURNING id, created_at, updated_at;
	`
	row := db.QueryRow(
		sql,
		p.FirstName,
		p.LastName,
		p.Team,
		p.Number,
		time.Now(),
		time.Now(),
	)
	err = row.Scan(&p.ID, &p.CreatedAt, &p.UpdatedAt)
	return
}

var db *sql.DB

func init() {
	var err error
	db, err = sql.Open(
		"postgres",
		"user=gosql_user dbname=gosql password=secret sslmode=disable",
	)
	if err != nil {
		panic(err)
	}
}

func main() {
	player := &player{
		FirstName: "Stephen",
		LastName:  "Curry",
		Team:      "Golden State Warriors",
		Number:    30,
	}
	fmt.Printf("%#v\n\n", player)
	player.Create()
	fmt.Printf("%#v\n", player)
}
```

Notice we're setting the `created_at` and `updated_at` with the `time.Now()` method from the `time` package.

Then execute:

```bash
$ go run main.go
# &main.player{ID:0, FirstName:"Stephen", LastName:"Curry", Team:"Golden State Warriors", Number:30, CreatedAt:time.Time{sec:0, nsec:0, loc:(*time.Location)(nil)}, UpdatedAt:time.Time{sec:0, nsec:0, loc:(*time.Location)(nil)}}
#
# &main.player{ID:5, FirstName:"Stephen", LastName:"Curry", Team:"Golden State Warriors", Number:30, CreatedAt:time.Time{sec:63599895381, nsec:218326000, loc:(*time.Location)(0xc820012420)}, UpdatedAt:time.Time{sec:63599895381, nsec:218326000, loc:(*time.Location)(0xc820012420)}}
```

Notice that the player struct being printed out has picked up `ID`, `CreatedAt` and `UpdatedAt` values after executing the `player.Create()` method.

After executing this, you should have a player in your `players` table:

```bash
$ psql -U gosql_user gosql -c "SELECT * FROM players"
# id | first_name | last_name |         team          | number
# ----+------------+-----------+-----------------------+--------
#  1 | Stephen    | Curry     | Golden State Warriors |     30
# (1 row)
```

The `Scan` method of the returned `sql.Row` is responsible for populating variables with the row data. The `Scan` sourcecode looks like:

```go
// Scan implements the Scanner interface.
func (n *NullBool) Scan(value interface{}) error {
	if value == nil {
		n.Bool, n.Valid = false, false
		return nil
	}
	n.Valid = true
	return convertAssign(&n.Bool, value)
}
```

Then the `convertAssign` function's code [is here](https://gist.github.com/elliotlarson/f6aa0076fdbc147afd07a3180015af2d).

## Getting a record

Say you have a player in your database with an ID of `5`.  Again, we can use the combination of `QueryRow` and `Scan` to get the data and add it to our `player` struct.

```go
func GetPlayerById(id int) (p player) {
	sql := `
		SELECT
			id, first_name, last_name, team, number, created_at, updated_at
		FROM
			players
		WHERE
			id = $1
	`
	row := db.QueryRow(sql, id)
	p = player{}
	err := row.Scan(
		&p.ID,
		&p.FirstName,
		&p.LastName,
		&p.Team,
		&p.Number,
		&p.CreatedAt,
		&p.UpdatedAt,
	)
	if err != nil {
		panic(err)
	}
	return
}

func main() {
	player := GetPlayerById(5)
	fmt.Printf("%#v\n", player)
}
```

## Updating a record

Here we're using the `Exec` method.  This is good for SQL commands where you don't need a result.

```go
func (p *player) Update() (err error) {
	sql := `
		UPDATE players SET
			first_name = $2, last_name = $3, team = $4, number = $5, updated_at = $6
		WHERE id = $1;
	`
	_, err = db.Exec(
		sql,
		p.ID,
		p.FirstName,
		p.LastName,
		p.Team,
		p.Number,
		time.Now(),
	)
	return
}

func main() {
	player := GetPlayerById(5)
	fmt.Printf("%#v\n", player)

	player.FirstName = "Klay"
	player.LastName = "Thompson"
	player.Number = 11
	player.Update()

	player = GetPlayerById(5)
	fmt.Printf("%#v\n", player)
}
```

## Selecting records

You can select a set of records with the `sql.Query` method.  This returns an `sql.Rows` collection that you can iterate through with the help of the `Next` method on the returned `*sql.Rows` struct.  

Also, notice that we call the `Close` method on this struct pointer when we're finished iterating through the rows.  Technically, when `rows.Next()` returns false, this is done anyways, but doing it manually is a best practice.

```go
func ScanPlayerFromRow(rs interface {
	Scan(des ...interface{}) error
}) (p player) {
	err := rs.Scan(
		&p.ID,
		&p.FirstName,
		&p.LastName,
		&p.Team,
		&p.Number,
		&p.CreatedAt,
		&p.UpdatedAt,
	)
	if err != nil {
		panic(err)
	}
	return
}

func GetPlayers() (players []player) {
	sql := `
		SELECT
			id, first_name, last_name, team, number, created_at, updated_at
		FROM
			players
		ORDER BY
			last_name
	`
	rows, err := db.Query(sql)
	if err != nil {
		panic(err)
	}
	for rows.Next() {
		p := ScanPlayerFromRow(rows)
		players = append(players, p)
	}
	rows.Close()
	return
}

func main() {
	player1 := player{
		FirstName: "Stephen",
		LastName:  "Curry",
		Team:      "Warriors",
		Number:    30,
	}
	player1.Create()

	player2 := player{
		FirstName: "Klay",
		LastName:  "Thompson",
		Team:      "Warriors",
		Number:    11,
	}
	player2.Create()

	player3 := player{
		FirstName: "Draymond",
		LastName:  "Green",
		Team:      "Warriors",
		Number:    23,
	}
	player3.Create()

	players := GetPlayers()
	for _, player := range players {
		fmt.Printf(
			"ID: %d, Name: %s %s, Number: %d\n",
			player.ID,
			player.FirstName,
			player.LastName,
			player.Number,
		)
	}
}
```

Here I've outsourced the scanning part of the data access method to another function that could be used by both `GetPlayerById` and `GetPlayers`.  Notice the interface argument.  [This Stack Overflow question](http://stackoverflow.com/questions/37504735/create-a-function-that-accepts-two-different-objects-that-have-the-same-method) talks about this.

## Resources

* http://go-database-sql.org/
