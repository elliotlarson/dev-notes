# Django Notes

## Connecting to Postgres

Here is the [database settings documentation](https://docs.djangoproject.com/en/1.10/ref/settings/#std:setting-DATABASES).

You will need to have [psychopg](http://initd.org/psycopg/) installed:

```bash
$ python -m pip install psychopg2
```

In your `mysite/settings.py` file setup postgres with:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'mydatabase',
        'USER': 'mydatabaseuser',
        'PASSWORD': 'mypassword',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}
```

## Models

Here is the [model documentation](https://docs.djangoproject.com/en/1.10/topics/db/models/).

In your app models file you can setup a model with:

```python
from django.db import models

class Person(models.Model):
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
```

This is very DataMapper like from the Ruby world, where you describe your model's fields in the model itself instead of in a migration file as you would in Rails.
