# Python Builting Notes

## Len

The len function can be called with an number of types to provide their length.

```python
print(len("Elliot")) #=> 5
print(len([1, 2])) #=> 2
```

Calling this method actually calls the `__len__` method on the object.  So the string example resolves to `"Elliot".__len__()` and the list example resolves to `[1, 2].__len__()`.

## Range

Range is an immutable sequence data type.  It can be used to iterate over a range of numbers:

```python
for i in range(1, 5):
    print(i)
```