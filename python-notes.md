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
