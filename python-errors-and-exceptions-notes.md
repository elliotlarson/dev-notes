# Python Errors and Exceptions

## Manually raising an exception

To raise your own exception use the `raise` method:

```python
raise ValueError('That value not so good')
```

[Here's the documentation on the available exception classes](https://docs.python.org/3/library/exceptions.html#exception-hierarchy)

## Handling errors

Like other languages, Python has a `try` construct:

```python
try:
    raise NameError('Bad name')
except NameError:
    print('Got a name error')
    raise
```

You can also pass the error message:

```python
try:
    raise NameError('Bad name')
except NameError as err:
    print('Got a name error: "{}"'.format(err))
```

You can also catch other errors with a final, catchall `except`:

```python
import sys
try:
    raise ValueError('Bad value')
except NameError as err:
    print('Got a name error: "{}"'.format(err))
except:
    print('Got some other error: "{}"'.format(sys.exc_info()[0]))
```

You can execute code if not exceptions are raised with and `else`:

```python
try:
    pass
except NameError as err:
    print('Got a name error: "{}"'.format(err))
else:
    print('No exception raised')
```

You can execute followup code whether or not an exception is raised with `finally`:

```python
try:
    pass
except NameError as err:
    print('Got a name error: "{}"'.format(err))
finally:
    print('Always executing this code')
```
