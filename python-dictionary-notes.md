# Python Dictionary Notes

## Creating a dictionary whose default is a zero

This can be useful for looping through a collection and building up counts.  The [defaultdict](https://docs.python.org/3/library/collections.html#collections.defaultdict) is a dictionary-like data structure.

```python
from collections import defaultdict

chars_hash = defaultdict(int) # default value for undefined key is zero int
for char in 'apple':
    chars_hash[char] += 1

print(chars_hash)
#=> defaultdict(<class 'int'>, {'a': 1, 'p': 2, 'l': 1, 'e': 1})
```
