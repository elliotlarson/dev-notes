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
