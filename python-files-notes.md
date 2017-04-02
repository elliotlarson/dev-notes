# Python Files Notes

Say you have the following file `number-words.txt` with the contents:

```text
one
two
three
```

## Reading a file 

## One line at a time

To open a file for reading, you use the `open` method, passing in the `r` option for "read".

```python
file = open('number-words.txt', 'r')
for line in file:
    print(line.strip())
file.close()
```

### Reading whole file in as a list of lines

With readlines, you read in the contents of a file as a list of lines:

```python
file = open('number-words.txt', 'r')
number_words_lines = file.readlines() 
file.close()
```

This will give you a newline character at the end of each line in your list, so it's common to use a list comprehension to process the lines:

```python
number_words = [elt.strip() for elt in file.readlines()]
```

### Reading whole file in as a string

You can read the entire contents in at once with `read`.

```python
file = open('number-words.txt', 'r')
number_words_contents = file.read()
file.close()
```

Remember to close the file handle when you are finished.

## Writing to a file

### Writing to a file a line at a time

To write to a file, you need to open it with the `w` flag:

```python
file = open('number-words.txt', 'w')
file.write('four')
file.close()
```

**HOWEVER**: This will not append the word "four" to the file, it will overwrite it with the word "four". 

To append, use the `a` flag:

```python
file = open('number-words.txt', 'a')
file.write('four')
file.close()
```

### Writing a list to a file all at once

You can use `writelines` for this:

```python
new_numbers = ['four', 'five']
with open('number-words.txt', 'a') as file:
    file.writelines(new_numbers)
```

## Auto closing a file with `with` 

**Note:** the current convention is to do it this way most of the time.

The advantage of using `with` is that it closes the file handle automatically:

```python
with open('number-words.txt', 'r') as file:
    for line in file:
        print(line.strip())
```

## Working with csv files

### Reading a csv file

Say you have a csv file `users.csv`:

```csv
customerNo,firstName,lastName,birthDate,mailingAddress
1,John,Dunbar,13/06/1945,"1600 Amphitheatre Parkway Mountain View, CA 94043 United States"
2,Bob,Down,25/02/1919,"1601 Willow Rd. Menlo Park, CA 94025 United States"
3,Alice,Wunderland,08/08/1985,"One Microsoft Way Redmond, WA 98052-6399 United States"
4,Bill,Jobs,10/07/1973,"2701 San Tomas Expressway Santa Clara, CA 95050 United States"
```

You can read and work with this with the csv module:

```python
import csv

names = []

with open('users.csv', 'r') as f:
    rows = csv.reader(f)
    headers = next(rows)
    for row in rows:
        names.append("{} {}".format(row[1], row[2]))

print(names)
# => ['John Dunbar', 'Bob Down', 'Alice Wunderland', 'Bill Jobs']
```

### Writing a csv file

You can write with a csv writer:

```python
import csv 

with open('users.csv', 'a') as file:
    writer = csv.writer(file)
    writer.writerow([5, 'John', 'Doe', '123 Any St. San Francisco, CA 99999'])
```

The writer method also takes "dialect arguments" so you can change the writing format.  For example, you might want to change to tab delimited instead of commas. [More documentation on dialects here](https://docs.python.org/3/library/csv.html#csv.writer)
