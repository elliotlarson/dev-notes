# Python Testing Notes

Lets start with a trivial implementation file `greeter.py`:

```python
class Greeter(object):
    def __init__(self, name):
        self.name = name

    def greet(self):
        return 'Hi, {}!'.format(self.name)
```

## Unittest

[Unittest](https://docs.python.org/3/library/unittest.html) is the standard library testing package that comes with Python.  It is based on jUnit (Java-ness).

Here is a basic test file for greeter `tests/test_greeter.py`. The `test_` prefix is important for unittest.  It can automatically discover your tests, but it looks for files with this.

```python
import unittest
import greeter

class GreeterTest(unittest.TestCase):

    def setUp(self):
        self.gr = greeter.Greeter('Jim-bob')

    def test_greet(self):
        self.assertEqual(self.gr.greet(), 'Hi, Jim-bob!')

    def test_name(self):
        self.assertEqual(self.gr.name, 'Jim-bob')
```

Then, from the root of the working directory, you can run the tests with:

```bash
$ python -m unittest tests
```

You can run a single test file with:

```bash
$ python -m unittest tests/test_greeter.py
```

Testing a single test can be done with something like the following, **but this didn't work for me**:

```bash
$ python -m unittest tests/test_greeter.py tests.test_greeter.GreeterTest.test_greeter
```

### Some problems with unittest

* The API is very long winded, like jUnit
* The output is not colorized, showing red and green
* The verbose mode of the output (passing -v flag to command) is fairly useless
* The test file need to be prefixed with `test_`, but in most other languages a postifix is more standard (e.g. `_test.py` would be better)
* Testing a single test syntax is longwinded

## Pytest

[Pytest](https://docs.pytest.org/en/latest/index.html) solves many of the problems with unittest.

It simplifies the API.  Here is a similar test with pytest `tests/greeter_test.py`.  Notice the test can be postfixed with `_test.py` instead of prefixed.

```python
import pytest
import greeter

@pytest.fixture
def gr():
    return greeter.Greeter('Jim-bob')

def test_greet(gr):
    assert gr.greet() == 'Hi, Jim-bob!'

def test_name(gr):
    assert gr.name == 'Jim-bob'
```

You can run the tests in the `tests` directory with.  Notice the output is colorized for red/green TDD flow.

```bash
$ pytest
```

You can run a specific file with:

```bash
$ pytest tests/greeter_test.py
```

You can run in verbose mode to see which tests were run:

```bash
$ pytest -v
```

You can run a single test with

```bash
$ pytest -v tests/greeter_test.py::test_greet
```

Notice how much easier it is to call out an individual test than it is with unittest.

### Placing tests in `tests` directory

If you are seeing an error when trying to import your implementation module that is up one directory, you may need to add an `__init__.py` file to the root of your `tests` directory.

### Running iPython debugger in a test

Pytest captures output by default, but the `-s` option turns capturing off, which allows you to drop an iPython debug statement in your code:

```python
import pytest
import greeter
from IPython.core import debugger
debug = debugger.Pdb().set_trace

@pytest.fixture
def gr():
    return greeter.Greeter('Jim-bob')

def test_greet(gr):
    debug()
    assert gr.greet() == 'Hi, Jim-bob!'

def test_name(gr):
    assert gr.name == 'Jim-bob
```

```bash
$ pytest -s -v tests/greeter_test.py::test_greet
```
