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
