# Python Classes And Objects

## Some basic class/object examples:

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

## Getters and setters

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

## Method object implementation with Python

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

## Getting and setting instance properties dynamically

You can use the `getattr` and `setattr` methods to get and set properties on an instance:

```python
class MyObj(object):
    def __init__(self, name):
        self.name = name

me = MyObj('Elliot')
getattr(me, 'name') #=> 'Elliot'
setattr(me, 'name', 'Billybob')
getattr(me, 'name') #=> 'Billybob'
```
