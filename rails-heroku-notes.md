# Heroku Rails Notes

Heroku CLI commands documentation: https://devcenter.heroku.com/articles/heroku-cli-commands

## Setting up a custom domain

This was a little more painful than expected.  Heroku won't give you an IP address, so you can't create a traditional A record for your bare domain.

You can use CloudFlare to manage your DNS, and Cloudflare allows you to add in a CNAME for a root domain that it "flattens".

### View domains

```bash
$ heroku domains
```

### Add domain

```bash
$ heroku domains:add www.onehouse.io
```

## View information about certificates

```bash
$ heroku certs:auto
```

## View configuration

```bash
$ heroku config
```

## Set a config variable

```bash
$ heroku config:set FOO="bar"
```

## Add the current directory to app

If you haven't connected to an app yet, you need to issue all of your heroku commands with an `--app` flag.

To connect to the app:

```bash
$ heroku git:remote -a <app name>
```
