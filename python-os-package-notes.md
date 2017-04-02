# Python `os` Package Notes

This is the standard operating system library.

## Working with environment variables

Getting:

```python
os.getenv('MY_VAR')
```

Setting:

```python
os.putenv('MY_VAR', 'foo')
```

## Getting the current directory

This gets the directory of the current file

```python
path = os.path.dirname(os.path.abspath(__file__))
```

This gets the current directory of the execution context.  So, if this code is in a module in a sub directory and we import it into a script that we run, it will not report the directory of the file the code is in.  It will report the directory of the script that's getting executed.

```python
import os
path = os.getcwd()
```
