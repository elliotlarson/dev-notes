# Django Notes

## Connecting to Postgres

You will need to have [psychopg](http://initd.org/psycopg/) installed:

```bash
$ python -m pip install psychopg2
```

In your `mysite/settings.py` file:

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
