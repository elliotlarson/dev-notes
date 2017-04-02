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

### Importing from a directory (packages)

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

This is referred to as a "package".  In earlier versions of Python you needed to include an `__init__.py` file in a directory to make it a package.  However this is implicit now and not required.

The `__init__.py` file can be a good place to put initialization code, if you're package needs any.  The file is only loaded and executed the first time a package is imported.

Inside of a package you need to import things slighly differently.  Lets say you have a file `biz/baz.py` and you need to import `biz/foo.py` into it to get the `bar` method:

```python
# baz.py
from .foo import bar

bar()
```

The dot prefix tells the Python importer to look in the current package.

### Search path

When a module name is used, Python will first look locally and then it will look up a series of directories, which you can access with the `sys` module:

```python
import sys

print(sys.path)
```

### Find out what a module defines

You can use the `dir` method to figure out what a module defines:

```python
import biz.foo

dir(biz.foo)
#=> ['__builtins__', '__cached__', '__doc__', '__file__', '__loader__', '__name__', '__package__', '__spec__', 'bar']
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

