# Docker Compose Notes

Assuming you have a Dockerfile in the current directory, you can create a `docker-compose.yml` file:

```yaml
version: '3'

services:

  web:
    build: .
    ports:
      - '3000:3000'
    volumes:
      - .:/usr/src/app
```

This uses the `Dockerfile` in the current directory to build an image and run a container based on it, binding port 3000 on in the container to 3000 on the host machine.  It also sets up the current directory as a shared volume in `/usr/src/app` in the container.

To run this compose file:

```bash
$ docker-compose up
```

You can also run this in detached mode:

```bash
$ docker-compose up -d
```

If you don't run in detached mode, you will see the output from the various services, each marked with the name of the service.

For example, a Rails server would look like:

```text
web_1  | => Booting Puma
web_1  | => Rails 5.2.2 application starting in development
web_1  | => Run `rails server -h` for more startup options
web_1  | Puma starting in single mode...
web_1  | * Version 3.12.0 (ruby 2.6.0-p0), codename: Llamas in Pajamas
web_1  | * Min threads: 5, max threads: 5
web_1  | * Environment: development
web_1  | * Listening on tcp://0.0.0.0:3000
```

You can `ctrl-c` to stop the containers.

## Manually stopping container

You can stop all containers with:

```bash
$ docker-compose stop
```

...or, you can stop a specific service

```bash
$ docker-compose stop web
```

## Viewing running containers

```bash
$ docker-compose ps
```

## Manually starting and restarting a service

```bash
$ docker-compose start web
```

```bash
$ docker-compose restart web
```

## Viewing logs for specific service container

```bash
$ docker-compose logs -f web
```

## Running a single command on a service

```bash
$ docker-compose exec web bin/rails g model User first_name:string last_name:string
```

## Rebuilding images

```bash
$ docker-compose build web
```

## Stopping with compose

Compose will start up a network, containers, volumns, etc.  To clean up when you are done:

```bash
$ docker-compose down
```
