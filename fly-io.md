# Fly.io Notes

## Installing the CLI

```bash
$ brew install flyctl
```

## Logging In

```bash
$ fly auth login
```

## Add app to Fly

In the root of your app:

```bash
$ fly launch
```

## Scale the memory on the server

The basic free option does not have enough memory to handle Rails, so we need to scale it:

```bash
$ fly scale vm shared-cpu-1x --memory 512
```

## Connecting to REDIS

```bash
$ fly redis connect
```

## Connecting to Postgres

FYI: Once a secret is added to your app in Fly, it is no longer accessible with the secrets command.  To view the values you need to login to the server.

```bash
$ DATABASE_URL=<db-url> fly postgres connect -a <postgres-app-name>
```
