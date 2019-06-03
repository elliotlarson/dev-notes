# Ruby Bundler Notes

## Installing gems in `vendor/bundle`

To generate a `.bundler` directory and set variables for your current app:

```bash
$ bundle config --local path vendor/bundle
```

Make sure to add `vendor/bundle` to your `.gitignore`.

## Install gems with parallel processes

You can install gems using multiple cores on your machine to speed things up:

```bash
$ bundle install -j4
```
