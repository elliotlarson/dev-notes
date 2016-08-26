# Golang Time Notes

The `Time` value is an empty struct:

```go
type Time struct {}
```

The zero value of type Time is January 1, year 1, 00:00:00.000000000 UTC.

```go
fmt.Println(time.Time{})
// => 0001-01-01 00:00:00 +0000 UTC
```

You can ask a time if it is the zero value:

```go
if myTime.IsZero() {
  // do some stuff
}
```

## Creating a new time value

To get the current time:

```go
timeNow := time.Now()
```

Getting the time in UTC:

```go
timeNow := time.Now().UTC()
```

To get a time value specifying values:

```go
t := time.Date(2009, time.November, 10, 23, 0, 0, 0, time.UTC)
```

The `Date` signature is:

```go
func Date(year int, month Month, day, hour, min, sec, nsec int, loc *Location) Time
```

To parse the time from a formatted string:

```go
t, err := time.Parse(time.RFC3339, "2016-06-24T11:51:23-07:00")
```

## Date math

To get the datetime from 36 hours ago:

```go
t := time.Now().UTC().Add(-time.Hour * 36)
```

... or, from 45 minutes ago using a constant:

```go
const MINUTES_AGO_CUTOFF = 45
t := time.Now().UTC().Add((-1 * MINUTES_AGO_CUTOFF) * time.Minute)
```

Getting the hours between 2 dates:

```go
time1.Sub(time2).Hours()
```

... or, days:

```go
time1.Sub(time2).Hours() / 24
```
