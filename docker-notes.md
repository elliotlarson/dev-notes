# Docker Notes

## Build an image from a Docker file and run it

Say you have a directory with a `Dockerfile` and an `index.html` file.

`Dockerfile`

```text
FROM nginx:latest
WORKDIR /usr/share/nginx/html
COPY index.html index.html
```

`index.html`

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hello Docker</title>
  </head>
  <body>
    <h1>Hello, Docker!</h1>
  </body>
</html>
```

Build the image:

```bash
$ docker image build -t nginx-with-html .
```

Run a container of the image:

```bash
$ docker container run -p 80:80 --rm
```

If you want to upload this image to Docker Hub, you need to tag it:

```bash
$ docker image tag nginx-with-html:latest elliotlarson/nginx-with-html:latest
```

Think of tags as a composite of `<image-name>:<repository-name>`.

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

## Viewing the logs for a container

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

## Start a container and run bash

```bash
$ docker container run -it ubuntu:14.04 bash
```

To automatically remove the container when finished, use the `--rm` flag:

```bash
$ docker container run --rm -it ubuntu:14.04 bash
```

## Show Docker Networks

```bash
$ docker network ls
# => NETWORK ID          NAME                DRIVER              SCOPE
# => 8c8c0be73fb5        bridge              bridge              local
# => 9e306b3b7093        host                host                local
# => 1cde17949134        none                null                local
```

Docker has a default network subnet called `bridge` that connects the local host machine to the docker containers.

## Inspect a network

This will give more detailed info about the network and give information about the containers that are connected

```bash
$ docker network inspect <network-id>
```

## Connect a running container to a network

```bash
$ docker network connect <network-id> <container-id>
```

## Disconnect a running container to a network

```bash
$ docker network disconnect <network-id> <container-id>
```

## Run a container with a named volume (data volume)

You can create a named volumn that stores the data from a container to the host machine.  Docker places it in some Docker owned directory on the host machine.

```bash
$ docker container run -d --name psql -v psql:/var/lib/postgresql/data postgres
```

## Run a container with a volumn mapping (bind mounting)

You can map a directory in the container to a directory on the host machine.

```bash
$ docker container run -d --name nginx -p 80:80 -v $(pwd):/usr/share/nginx/html nginx
```

## Cleaning up with prune

To remove all containers and images, including any stopped or unused containers and images:

```bash
$ docker system prune -a
```

Remove all volumes:

```bash
$ docker volume prune
```

Verify that all is gone

```bash
$ docker container ls && docker images && docker volume ls
```