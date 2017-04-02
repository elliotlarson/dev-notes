# Python List Notes

Lists work similar to the way they do in Ruby:

```python
names = ['Jim', 'Zack', 'James']
names[0]
#=> Jim
names[0] = 'June'
names[0]
#=> June
```

You can get the last list item with:

```python
names[-1]
#=> James
```

## List slicing

[This stack overflow answer has a good description of slice notation](http://stackoverflow.com/questions/509211/explain-pythons-slice-notation)

```python
a[start:end] # items start through end-1
a[start:]    # items start through the rest of the array
a[:end]      # items from the beginning through end-1
a[:]         # a copy of the whole array
a[start:end:step] # start through not past end, by step

a[-1]    # last item in the array
a[-2:]   # last two items in the array
a[:-2]   # everything except the last two items
```

> **start:** the beginning index of the slice, it will include the element at this index unless it is the same as stop, defaults to 0, i.e. the first index. If it's negative, it means to start n items from the end.

> **stop:** the ending index of the slice, it does not include the element at this index, defaults to length of the sequence being sliced, that is, up to and including the end.

> **step:** the amount by which the index increases, defaults to 1. If it's negative, you're slicing over the iterable in reverse.

**Indexing:**

```text
 +---+---+---+---+---+---+
 | P | y | t | h | o | n |
 +---+---+---+---+---+---+
   0   1   2   3   4   5 
  -6  -5  -4  -3  -2  -1
```

```python
py = ['P', 'y', 't', 'h', 'o', 'n']
py[2:] # 3rd item to the end: ['t', 'h', 'o', 'n']
py[-3:] # last three items: ['h', 'o', 'n']
# the previous expands to the defaults
# py[-3:len(py):1]
py[::2]) # every 2nd item: ['P', 't', 'o']
py[2:5] # 3rd to 5th item exclusive of the end item: ['t', 'h', 'o']
```

## Adding an item to a list

You can add with the `append` method:

```python
names = ['Jim', 'Bob', 'Steve']
names.append('Joe')
print(names)
#=> ['Jim', 'Bob', 'Steve', 'Joe']
```

You can also insert an item at a specific index with `insert`:

```python
names = ['Jim', 'Bob', 'Steve']
names.insert(1, 'Joe') # add item before the second item
print(names)
#=> ['Jim', 'Joe', 'Bob', 'Steve']
```

You can add a list to a list with `extend`:

```python
names = ['Jim', 'Bob', 'Steve']
names.extend(['Joe', 'James'])
print(names)
#=> ['Jim', 'Bob', 'Steve', 'Joe', 'James']
```

## Removing an item from a list

You can remove the last item from a list with `pop`:

```python
names = ['Jim', 'Bob', 'Steve']
names.pop()
print(names)
#=> ['Jim', 'Bob']
```

You can remove the first element in a list that matches a value with `remove`:

```python
names = ['Jim', 'Bob', 'Steve', 'Bob']
names.remove('Bob')
print(names)
#=> ['Jim', 'Steve', 'Bob']
```

You can remove all items from a list with `clear`. This is the same as `del a[:]`:

```python
names = ['Jim', 'Bob', 'Steve', 'Bob']
names.clear()
print(names)
#=> []
```

## Ordering

You can sort:

```python
names = ['Jim', 'Bob', 'Steve']
names.sort()
print(names)
#=> ['Bob', 'Jim', 'Steve']
```

You can reverse:

```python
names = ['Jim', 'Bob', 'Steve']
names.sort()
print(names)
#=> ['Steve', 'Bob', 'Jim']
```

## Getting information about a list

You can get the length of the list:

```python
names = ['Jim', 'Bob', 'Steve', 'Bob']
print(len(names))
#=> 4
```

You can count the list items that match a value:

```python
names = ['Jim', 'Bob', 'Steve', 'Bob']
print(names.count('Bob'))
#=> 2
```

You can find the first index of an item matching a value:

```python
names = ['Jim', 'Bob', 'Steve', 'Bob']
print(names.index('Bob'))
#=> 1
```

## Copying an array

You can copy both of these ways:

```python
names = ['Jim', 'Bob', 'Steve', 'Bob']
names_copy_1 = names.copy()
names_copy_2 = names[:]
```

## List comprehensions

List comprehensions provide a concise syntax for list manipulation.  They basically amount to map in the front and filter in the back.

For example, this statement:

```python
greet_names = []
for name in names:
    greet_names.append("Hello, {}".format(name))  
print(greet_names)
```

... can be written:

```python
names = ['Jim', 'Bob', 'Steve', 'James']
greet_names = ["Hello, {}!".format(name) for name in names]
print(greet_names)
```

The `"Hello, {}!".format(name)` is the "map in the front" part, the rest is a standard looping statement, and it's wrapped in a set of `[]`s.


Here we stick a filter on the back:

```python
names = ['Jim', 'Bob', 'Steve', 'James']
greet_names = ["Hello, {}!".format(name) for name in names if name != 'Bob']
print(greet_names)
```

The `if name != 'Bob'` part is the "filter in the back".

## Iterating over a list with an index

You can use the `enumerate` method:

```python
ints = [1, 2, 3, 4, 5]
for idx, val in enumerate(ints):
    print(idx, val)
```
