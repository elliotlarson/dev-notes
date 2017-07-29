# SSH Notes

## Generating an SSH key

This will prompt you with some questions.  If you accept the defaults it will output:

* `id_rsa` = the private key
* `id_rsa.pub` = the public key

```bash
$ ssh-keygen -t rsa -b 4096 -C 'your_email@example.com'
```

## Logging into a remote server

```bash
$ ssh <username>@<host-url>
```

If your public key is not on the server, you will be asked to provide your password.

## Placing your public key on a server

If you place your public key on the server, it will no longer ask you for

You can execute this command

```bash
$ cat ~/.ssh/id_rsa.pub | ssh <username>@<host-url> "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"
```

... or, if you have the `ssh-copy-id` command on your system

```bash
$ ssh-copy-id <username>@<host-url>
```

## Creating a config entries

In your `~/.ssh/config` file you can add entries to make logging into servers easier

For example

```text
Host acme-staging
  HostName staging.acme-industries.com
  User deploy
  Port 30000
```

This will allow you to login with

```bash
$ ssh acme-staging
```

You can also specify a specific ssh key to use

```text
Host acme-staging
  HostName staging.acme-industries.com
  User deploy
  Port 30000
  IdentityFile ~/.ssh/acme-deploy.id_rsa.key
```

## Tunneling

### Connecting to a remote database server

If you have a `deploy` user account on the example.com server, you can tunnel local traffic from port 8000 through SSH to the localhost port of 5432 on the server.

1. Setup the tunnel

```bash
$ ssh -L 8000:localhost:5432 deploy@example.com -nNT
```

* `-T` = Disable pseudo-terminal allocation.
* `-n` = Redirects stdin from /dev/null (actually, prevents reading from stdin).  This must be used when ssh is run in the background.
* `-N` = Do not execute a remote command.  This is useful for just forwarding ports.

2. Connect to the database

```bash
$ psql -U <db-username> -p 8000 <db-name>
```