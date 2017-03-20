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
        print("Notified: %s\n" % self.full_name())
        
    @staticmethod
    def notify_people(people):
        embed()
        map('notify', people)
        
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
