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
