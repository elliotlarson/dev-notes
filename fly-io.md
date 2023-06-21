# Notes on Moving to Fly.io

https://fly.io/docs/rails/getting-started/migrate-from-heroku/

## Setting up the accounts

```bash
$ fly launch
```

## Environment variables

Setting secrets:

```bash
$ fly secrets set MAILGUN_API_KEY=12345
```

Get a list of secrets:

```bash
$ fly secrets list
```

## Deployment

```bash
$ fly deploy
```

## SSL certificates

```bash
$ fly certs create myapp.com
```

This will output the AAAA record value that you need to add to the DNS manager.

## Running seeds

Make sure the system has the `ALLOW_SEED` env var.

```bash
$ fly secrets set ALLOW_SEEDS=true
```

Then run the console command:

```bash
$ fly ssh console -C "app/bin/rails db:seed" -a myapp
```

## Get information about Redis

Get the Redis servers

```bash
$ fly redis list
```

Get information, including connection URL:

```bash
$ fly redis status myapp-redis
```

Add the Redis URL env var:

```bash
$ fly secrets set REDIS_URL=<redis_url>
```

## Running the rails console

```bash
$ fly ssh console
$ cd app
$ bin/rails console
```

## Scaling a VM

Get the scale of the current VMs:

```bash
$ fly scale show
```

Get the VM scale options:

```bash
$ fly platform vm-sizes
```

Changing the VM used:

```bash
$ fly scale vm dedicated-cpu-1x
```

Upgrading the VM memory:

```bash
$ fly scale memory 1024
```

Getting the scale status:

```bash
$ fly status
```

## Connecting to REDIS

```bash
$ fly redis connect
```

## Connecting to Fly.io Postgres

FYI: Once a secret is added to your app in Fly, it is no longer accessible with the secrets command.  To view the values you need to login to the server.

```bash
$ DATABASE_URL=<db-url> fly postgres connect -a <postgres-app-name>
```
