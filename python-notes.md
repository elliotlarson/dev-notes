# Python Notes

## Setting up an app environment

### Using pyenv for working with Python versions

You can use [pyenv](https://github.com/pyenv/pyenv) to work with different versions of python.

To install:

```bash
$ brew install pyenv
```

Pyenv works with shims.  To use them, we need to add this to our shell config:

```bash
eval "$(pyenv init -)"
```

Install a version of Python:

```bash
$ pyenv install 3.6.0
```

Use a pyenv version globally:

```bash
$ pyenv global 3.6.0
```

Use a pyenv version locally:

```bash
$ pyenv local 3.6.0
```

This will add a `.python-version` file to the local directory.  When you enter this directory, pyenv will recognize the version of Python you want to use.  If this version is not installed, pyenv will let you know you need to install it.

### Managing a virtual environment with pyenv-virtualenv

[pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) will allow you to set the version of Python you want to use for a project, and have a contained set of packages (like having a separate gemset in the Ruby world).

Install:

```bash
$ brew install pyenv-virtualenv
```

Create a new environment:

```bash
$ pyenv virtualenv 3.6.0 my-project-3.6.0
```

List virtual envs:

```bash
$ pyenv vitualenvs
```

Remove a virtual env:

```bash
$ pyenv uninstall my-project-3.6.0
```

Use a virtual env for the current project:

```bash
$ pyenv local my-project-3.6.0
```

## Figure out the location of python

Sometimes you want to know where the location of the installed python you are using is:

```bash
$ pyenv which python
```

## Installing a package

You can use the [pip package manager](https://pip.pypa.io/en/stable/) to install a package:

```bash
$ python -m pip install pylint
```

## Dependency management

After installing a pip package, you can create a requirements file that other can use to load the same packages:

```bash
$ python -m pip freeze > requirements.txt
```

Then someone else can load the requirements file:

```bash
$ python -m pip install -r requirements.txt
```

## Useful idioms 

### Running code only if not being imported

Sometimes you only want to code to execute if it's being run directly, not when it's being imported.

From the documentation:

> '__main__' is the name of the scope in which top-level code executes. A module’s __name__ is set equal to '__main__' when read from standard input, a script, or from an interactive prompt.

```python
def main():
    pass

if __name__ == "__main__":
    main()
```

### Method object implementation with Python

```python
class Add(object):
    @classmethod
    def call(cls, number_one, number_two):
        return cls(number_one, number_two)._call()

    def __init__(self, number_one, number_two):
        self.number_one = number_one
        self.number_two = number_two

    def _call(self):
        return self.number_one + self.number_two

print(Add.call(1, 2))
```

## Classes and objects

Here's some basic class/object examples:

```python
class Person(object):
    role = 'undefined'

    def __init__(self, first_name, last_name, email=''):
        self.first_name = first_name
        self.last_name = last_name
        self.email = email

    def full_name(self):
        return self.first_name + ' ' + self.last_name 
    
    def designation(self):
        return self.full_name() + ' - ' + self.role

    def __str__(self):
        return self.designation()
        
    def notify(self):
        # => notification code
        print("Notified: %s" % self.full_name())
        
    @staticmethod
    def notify_people(people):
        for person in people:
            person.notify()
        
class Contractor(Person):
    role = 'contractor'

class Employee(Person):
    role = 'employee'

class Project(object):
    def __init__(self, description, participants=[]):
        self.description = description
        self.participants = participants

    @classmethod
    def from_accounting_string(cls, accounting_string):
        # 'Intranet | C:Doe, John | E:Doe, Jane'
        project_name = accounting_string.split(' | ')[0]
        participant_strings = accounting_string.split(' | ')[1:]
        participants = []
        participant_type_cls = { 'C': Contractor, 'E': Employee }
        for participant_string in participant_strings:
            participant_type_char = participant_string[0]
            first_name = participant_string[2:].split(', ')[1]
            last_name = participant_string[2:].split(', ')[0]
            participants.append(
                participant_type_cls[participant_type_char](first_name, last_name)
            )
        return cls(project_name, participants)

    def add_participant(self, participant):
        self.participants.append(participant)

    def __str__(self):
        return self.description + "\n  participants: " + \
            ', '.join(map(str, self.participants))

john = Contractor('John', 'Doe', 'john.doe@example.com')
print(f'Person: {john}')
jane = Employee('Jane', 'Doe', 'jane.doe@example.com')
print(f'Person: {jane}')

project = Project('Request for funds system', [john, jane])
print(f'Project: {project}')

billy = Employee('Billy', 'Bob', 'billy.bob@example.com')
print(billy)
project.add_participant(billy)
print(f'Project: {project}')

accounting_string = 'Intranet | C:Doe, John | E:Doe, Jane'
project2 = Project.from_accounting_string(accounting_string)
print(f'Project: {project2}')

people = [john, jane, billy]
Person.notify_people(people)
```

Some notes about this code:

* A basic object that doesn't inherit from anything inherits from `object` (e.g. `class Person(object):`).  This isn't enforcesd but it's suggested by `pylint`
* **Inheritance** works by providing the parent object to the child object's declaration (e.g. `class Contractor(Person):`).  You can inherit from multiple objects (e.g. `class Employee(Person, HealthInsuranceRecipient)`).
* The **`__init__`** method is the constructor
* The constructor and all **instance methods** take `self` as the first argument
* You assign an **instance variable** with `self.<variable> = <value>`.  Once assigned, this becomes available in other instance methods via `self.<variable>`.  It's also available externally on instance objects.
* The **`__str__`** method on an object is what is called when converting an object into a string (like when printing an instance)
* **Class variables** are defined like variables in the class scope.  These are then accessible like instance variables with `self.<variable>` because Python looks up the value in the object instance first; if it doesn't find anything, then it looks at the class.
* **Class methods** are prefixed with a `@classmethod` decorator.  They receive the class as the first variable.  The convention is to call this argument `cls`.
* **Custom constructors** are generally class methods, conventionally prefixed with `from_`

### Getters and setters

```python
class Person(object):
    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name 

    @property
    def full_name(self):
        return "{} {}".format(self.first_name, self.last_name)

    @full_name.setter 
    def full_name(self, name):
        self.first_name = name.split(' ')[0]
        self.last_name = name.split(' ')[1]

elliot = Person("Elliot", "Larson")
print(elliot.full_name)
elliot.full_name = "John Doe"
print(elliot.full_name)
```

## Debugging

### With pdb

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

### With pudb

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

### With iPython

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

### Printing out an object

On a console you may want to print out an object.

**Option #1**: Convert it to a string, which calls the `__str__` method.

```python
str(my_object)
```

**Option #2**: Print out the object data in dictionary style.

```python
vars(my_object)
```

## Errors and Exceptions

### Manually raising an exception

To raise your own exception use the `raise` method:

```python
raise ValueError('That value not so good')
```

[Here's the documentation on the available exception classes](https://docs.python.org/3/library/exceptions.html#exception-hierarchy)

### Handling errors

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
 
## Working with Files

Say you have the following file `number-words.txt` with the contents:

```text
one
two
three
```

### Reading a file a line at a time

To open a file for reading, you use the `open` method, passing in the `r` option for "read".

```python
file = open('number-words.txt', 'r')
for line in file:
    print(line.strip())
file.close()
```

### Reading in the lines of a file with `readlines`

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

### Reading a file with `read`

You can read the entire contents in at once with `read`.

```python
file = open('number-words.txt', 'r')
number_words_contents = file.read()
file.close()
```

Remember to close the file handle when you are finished.

### Writing to a file

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

### Reading a writing a file with `with`

The advantage of using `with` is that it closes the file handle automatically:

```python
with open('number-words.txt', 'r') as file:
    for line in file:
        print(line.strip())
```

### Writing an array to a file as lines

You can use `writelines` for this:

```python
new_numbers = ['four', 'five']
with open('number-words.txt', 'a') as file:
    file.writelines(new_numbers)
```

### Reading and working with csv

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

## The `os` package

This is the standard operating system library.

### Working with environment variables

Getting:

```python
os.getenv('MY_VAR')
```

Setting:

```python
os.putenv('MY_VAR', 'foo')
```


### Getting the directory of the current script

```python
path = os.path.dirname(os.path.abspath(__file__))
```

There is also this approach:

```python
import os
path = os.getcwd()
```

## The `sqlite` package

### Executing a query

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

### Getting a single result

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

### Executing a query passing in a value

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

### Mutating data

If you are mutating data, you need to remember to call `commit`.

```python
import sqlite3

connection = sqlite3.connect('mydb.db')
cursor = connection.cursor()
cursor.execute('insert into projects values(?,?)', ('foo', 'bar'))
cursor.commit()
connection.close()
```

### Inserting multiple records

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

## Plotting with `matplotlib`

### Set the rendering engine

When I first tried to use matplotlib the first time I encountered the error:

> RuntimeError: Python is not installed as a framework. 

This is a common, ongoing problem that seems to have been around for years.  It has to do with the default rendering engine on Mac OS not being appropriate for matplotlib:

[Here's a good article that talks about it](http://www.wirywolf.com/2016/01/pyplot-in-jupyter-inside-pyenv-on-el-capitan.html).

**Approach #1**

NOTE: This didn't work for me.

On the Mac you need to manually set the backend rendering engine (not sure why they couldn't do this for you).

Figure out the location of matplotlib:

```bash
$ python -c "import matplotlib; print(matplotlib.__path__)"
```

Go to the root of the lib and add the necessary config file:

```bash
$ vi matplotlibrc
# => add: "backend: TkAgg"
```

**Approach #2**

NOTE: This approach did work for me.

You can also set the rendering engine in your Python script:

```python
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot
```

### Save output as SVG file

```python
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt
import numpy as np
x = np.arange(0,100,0.00001)
y = x*np.sin(2*np.pi*x)
plt.plot(y)
plt.savefig("test.svg", format="svg")
```

## Jupyter notebooks

This is a tool used to explain data with a combination of input output sections, markdown sections, and visualizations/graphs.

### Install

It's recommended that you run Jupyter with Anaconda.  But, if you don't want to run Anaconda, you can just install it directly with pip.

```bash
$ python -m install jupyter
```

### Running

Jupyter is a server that you can run locally.

```bash
$ jupyter notebook
```

This will launch a server on port 8888.  When you create files in your notebook, the resulting file is saved in the directory you're running the server in as a `.ipynb` file.
