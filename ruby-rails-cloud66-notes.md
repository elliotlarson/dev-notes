# Cloud 66 Notes

## Directories

* **Failed deploys**: `/tmp/c66-recent-deploy-fail`
* **App location**: `/var/deploy/<app-name>/web_head`
  * **Logs**: `/var/deploy/<app-name>/web_head/shared/logs`
  * **Nginx logs**: `/var/log/nginx`

## Commands

**Manually restart server**:

```bash
$ sudo systemctl restart cloud66_web_server.service
```

**Check status of nginx**:

```bash
$ systemctl status nginx.service
```

## Install toolbelt

Follow instructions on this page: https://app.cloud66.com/toolbelt

## Managing multiple accounts

You can do this with profile configurations:

```bash
$ cx config create personal
```

This will add profile information to the `~/.cloud66` directory.

You can use the profile with:

```bash
$ cx config use personal
```

To login with this profile via the browser:

```bash
$ cx login
```

## Getting a list of environment variables

Applications are called "stacks" in Cloud66.

You can view a list of env vars for a stack:

```bash
$ cx env-vars list --stack my-app
```

## Deployment

```bash
$ cx redeploy --stack my-app --listen
```

## Get list of servers for a stack

```bash
$ cx servers list --stack my-app
```

## SSH into server

You need to get a list of the server names and then you can login to a specific one with:

```bash
$ cx ssh --stack my-app server-name
```

## Uploading a file to a server

```bash
$ cx upload --stack my-app --server foo db/prod.dump /tmp/prod.dump
```

## Tail a log file

```bash
$ cx tail --stack my-app web nginx_error.log
```

## Multiple profiles

If you have multiple accounts on Cloud66, you can use the `profiles` feature of the toolbelt to switch between them:

Creating a profile:

```bash
$ cx config create <name>
```

Using a profile:

```bash
$ cx config use <name>
```
