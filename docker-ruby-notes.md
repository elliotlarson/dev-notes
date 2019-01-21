# Docker Ruby Notes

## Running a Rails server in a Docker container

Add this to your app's directory: `Dockerfile`

```Dockerfile
FROM ruby:2.6
RUN apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
    nodejs
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN bundle install
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
```

The `-b 0.0.0.0` tells the rails server to accept traffic from any location, not just localhost.  Since we're running in a container, the traffic coming from our host machine to the Docker container will not be localhost.

Build the image from this Dockerfile:

```bash
$ docker build . -t myapp:1.0 -t myapp
```

Here I'm creating multiple tags, a versioned tag and an easy to use generic tag.

After the command finishes, you should see the unique ID assigned to it.

Run a container from the image:

```bash
$ docker run -p 1234:3000 myapp
```

This will run the Rails app in the container and make it availabe on your host machine at port 1234.

This results in an image that is just over 1G.  The base Ruby image uses Ubuntu.  For a smaller image you can use the Alpine Linux based Ruby image:

```Dockerfile
FROM ruby:2.6-alpine
RUN apk add --update \
    build-base \
    postgresql-dev \
    sqlite-dev \
    nodejs \
    tzdata \
    bash \
    && rm -rf /var/cache/apk/*
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app/
RUN bundle install
COPY . /usr/src/app/
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
```

This produces an image that is about 350MB.

## Ignoring files from the image build

You don't want to include some of the file from your app when you build the image.  To hide files we use a `.dockerignore` file.

```txt
.git
.gitignore
log/*
tmp/*
```

## Avoiding bundle install every time you edit a file

Let's say you have this config:

```Dockerfile
FROM ruby:2.6-alpine
RUN apk add --update \
    build-base \
    postgresql-dev \
    sqlite-dev \
    nodejs \
    tzdata \
    bash \
    && rm -rf /var/cache/apk/*
COPY . /usr/src/app/
WORKDIR /usr/src/app/
RUN bundle install
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
```

If you change the README in your app and then rebuild, the gems get installed again, which is slow.  Docker will cache the layers used to create each step of the build process, but we've updated a file causing the caches for steps after the `COPY` command to be busted.  So, bundle install needs to get run again.

To get around this, copy and the `Gemfile` and `Gemfile.lock` over first, run a bundle install and then copy the rest of the app files over.  This way the cache for the bundle install only needs to get run.

## Docker composing

Given a `docker-compose.yml` file:

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - '3000:3000'
    volumes:
      - .:/usr/src/app
  redis:
    image: redis
  database:
    image: postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: supersecret
      POSTGRES_DB: myapp_development
```

### Run it

You can start up the cluster of containers with:

```bash
$ docker-compose up
```

### Verify that the containers are running

You can view the running containers with:

```bash
$ docker-compose ps
```

### Access Redis

You can log into the Redis container with:

```bash
$ docker-compose run --rm redis redis-cli -h redis
```

This creates a new throw-away container based on the redis image and runs the `redis-cli` command with the `-h` or host flag pointing at the already running redis container.  The magic of docker compose's networking means the running redis container can just be refered to by the name "redis".

### Access Postgres

```bash
$ docker-compose run --rm postgres psql -U postgres -h postgres
```

After entering the password you should be in.

### Rebuild to add in new gems

After you add a new gem to the Gemfile, to run `bundle install` you need to rebuild the image:

```bash
# stop the container
$ docker-compose stop web
# build the image
$ docker-compose build web
# restart the web image
$ docker-compose up -d web
```
