# Debugging Python Notes

## Debugging with pdb

This is the Python debugger included in the standard library.  

Usage:

```python
import pdb

def buggy_method():
    pdb.set_trace()
```

When the code is executed, this will drop you into a pdb prompt at the trace point in your code.

At the prompt you can ask for help:

```bash
(Pdb) h

Documented commands (type help <topic>):
========================================
EOF    c          d        h         list      q        rv       undisplay
a      cl         debug    help      ll        quit     s        unt
alias  clear      disable  ignore    longlist  r        source   until
args   commands   display  interact  n         restart  step     up
b      condition  down     j         next      return   tbreak   w
break  cont       enable   jump      p         retval   u        whatis
bt     continue   exit     l         pp        run      unalias  where

Miscellaneous help topics:
==========================
exec  pdb

(Pdb) h a
a(rgs)
        Print the argument list of the current function.
```

## Debugging with pudb

[Pudb](https://pypi.python.org/pypi/pudb) is more of a full fledged interactive, console based debugger.

Install:

```bash
$ python -m pip install pudb
```

Usage:

```python
from pudb import set_trace

def buggy_method():
    set_trace()
```

## Debugging with iPython

[iPython](http://ipython.readthedocs.io/en/stable/index.html) is a feature rich repl, kind of like a more powerful version of Ruby's pry.

You can use it to debug by "embedding" it in your source.  When you run your code, the `embed()` statement will launch an iPython terminal at that point in your code, at which point you can poke around.

Install:

```bash
$ python -m pip install ipython
```

**Usage #1** (more repl than debug):

```python
from IPython import embed

def buggy_method():
    set_trace()
```

However, this doesn't give you debug capabilities, like code listing and stepping into methods.

**Usage #2** (more debug):

```python
from IPython.core import debugger
debug = debugger.Pdb().set_trace

def buggy_method():
    debug()
```

## Printing out an object

On a console you may want to print out an object.

**Option #1**: Convert it to a string, which calls the `__str__` method.

```python
str(my_object)
```

**Option #2**: Print out the object data in dictionary style.

```python
vars(my_object)
```
