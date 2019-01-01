# Docker Notes

## Zsh docker completions

If you are using oh-my-zsh, then you can just use the docker plugin:

In your `.zshrc` file, make sure the plugins line has:

```bash
plugins+=(docker)
```

## Pull down a docker image

This will pull down the latest image:

```bash
$ docker pull alpine
```

## Run an nginx container

```bash
$ docker container run -p 8888:80 nginx
```

This will download the nginx latest from the Docker Hub, or use a local version if found, and run it.  You should now be able to navigate to http://localhost to view the vanilla nginx container running.

When you view the page, you will see the log output in your terminal.

The `-p` flag connects port 8888 on the host machine to port 80 in the container.

## Specify a name for the container

```bash
$ docker container run -p 8888:80 --name webhost nginx
```

## Figure out which port a docker container is connected to

```bash
$ docker container port

## View running containers

```bash
$ docker container ls
```

Notice that there is a name and an ID number.

## Show all containers, running and not

```bash
$ docker container ls -a
```

## Running in detached mode

If you don't want the process to take up your terminal process, you can run the container in detached mode:

```bash
$ docker container run -p 8888:80 --detach nginx
```

## Viewing the logs for a detached container

```bash
$ docker container logs <container-id-or-name>
```

## Stopping a running container

```bash
$ docker container stop <container-id-or-name>
```

## Listing processes that are running in a specific container

```bash
$ docker top <container-id-or-name>
```

## Removing a container

```bash
$ docker rm <container-id-or-name>
```

## Delete all stopped containers

```bash
$ docker rm $(docker ps -a -q)
```

## Get a list of Docker images

```bash
$ docker image ls
```

## View how the container was run

```bash
$ docker container inspect
```

## View stats for all running containers

This allows you to see memory usage, memory limit, and CPU usage.

```bash
$ docker container stats
```

## Access a command line for a running container

The `-t` flag opens a tty prompt and the `-i` command keeps the prompt active.  `bash` is the command to run once the prompt has been established.

```bash
$ docker container exec -it nginx bash
```
