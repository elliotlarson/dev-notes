# The Python `sqlite` package

## Executing a query

```python
import sqlite3

connection = sqlite3.connect("mydb.db")
cursor = connection.cursor()
cursor.execute("select title from project limit 2") # the results now live in the cursor object
results = cursor.fetchall()
# the results are a list of tuples
# => [('project #1',), ('project #2',)]
project_titles = [elt[0] for elt in results]
connection.close()
```

## Getting a single result

```python
import sqlite3

connection = sqlite3.connect("mydb.db")
cursor = connection.cursor()
cursor.execute('select count(*) from projects')
result = cursor.fetchone()
# => (234,)
project_count = result[0]
print(project_count)
connection.close()
```

## Executing a query passing in a value

```python
import sqlite3

connection = sqlite3.connect('mydb.db')
cursor = connection.cursor()
id = 42
cursor.execute('select * from projects where id = ?', id)
result = cursor.fetchone()
print(result)
connection.close()
```

## Mutating data

If you are mutating data, you need to remember to call `commit`.

```python
import sqlite3

connection = sqlite3.connect('mydb.db')
cursor = connection.cursor()
cursor.execute('insert into projects values(?,?)', ('foo', 'bar'))
cursor.commit()
connection.close()
```

## Inserting multiple records

You can insert multiple records with `executemany`

```python
import sqlite3

connection = sqlite3.connect('mydb.db')
cursor = connection.cursor()
new_projects = [
    ('foo', 'bar'),
    ('baz', 'biz'),
]
cursor.executemany('insert into projects values(?,?)', new_projects)
cursor.commit()
connection.close()
```
