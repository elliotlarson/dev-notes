# Python Package and Modules Notes

## Basic module usage

Code in a file is referred to as a module.  You can encapsolate code in modules and then import them into other files.

Say you have a file `foo.py` with:

```python
def bar():
    print('baz')
```

In another script in the same directory, you can use the `bar` function like this:

```python
import foo

foo.bar()
#=> baz
```

You can also import the function like this:

```python
from foo import bar

bar()
#=> baz
```

### Importing from a directory

If the `foo` module is located in a directory, like `biz`

```bash
├── biz
│   └── foo.py
└── main.py
```

... you can import it like this

```python
from biz.foo import bar

bar()
```

... or, like this

```python
import biz.foo

biz.foo.bar()
```

### Search path

When a module name is used, Python will first look locally and then it will look up a series of directories, which you can access with the `sys` module:

```python
import sys

print(sys.path)
```

## Running code only if not being imported

Sometimes you only want to code to execute if it's being run directly, not when it's being imported.

From the documentation:

> '__main__' is the name of the scope in which top-level code executes. A module’s __name__ is set equal to '__main__' when read from standard input, a script, or from an interactive prompt.

```python
def main():
    pass

if __name__ == "__main__":
    main()
```

