# Docker Learning Notes

## Docker CI Workflow

I think the workflow should be something like this:

1. Develop and run tests locally
2. Once the tests pass locally, push up branch and create PR
3. CI is notified of the branch update
4. CI builds Docker image and runs tests and reports back to GitHub
5. When the PR is accepted, it’s merged into master
6. CI sees a new commit on master and pulls code, builds image, and runs specs
7. When specs pass, the image is pushed to the Docker registry
8. Then CI runs the stack command to update the swarm with the new

## Docker ToDos

[x] Figure out how to integrate CI
[ ] Figure out how to add selenium specs
[x] Work with Ubuntu base images instead to try it out
[ ] Learn how to use the swarm secrets.  What's better, Rails secrets or swarm... or both
[ ] Add Git sha for current commit to container
[ ] What to do with logging.  Does log rotate need to be hooked up?  What's the process for viewing historical logs.  How do we send logs to third party logging service?
[x] When you deploy an updated image to a server, the old ones remain.  Is this going to run the server out of space or is it going to remove older images after a time?
[ ] How do you setup a recurring task, like a cron job?  Do we create a cron container or do we use the system's crontab to run one off swarm services?
[ ] Swarm stack deploy rollback if something goes wrong
[ ] Figure out how to setup Nginx service proxying to Rails application services in the swarm
[ ] Multi-stage builds

## Stack deploy weirdness

When trying to do this command

```bash
$ docker stack deploy -c docker-stack.yml ohweb
```

It resulted in an error:

```text
error during connect: Get https://178.128.15.86:2376/v1.38/info: x509: certificate signed by unknown authority
```

To deal with this, I regenerated the swarm certificates:

```bash
$ docker-machine regenerate-certs ohweb
```

Then I grabbed the certs from the `/Users/elliot/.docker/machine/machines/ohweb` directory and added them to the CI.

Then when deploying after a successful build on CI, I saw this:

```bash
# Updating service ohweb_web (id: rr1sw2bdv9v6wi97ma1u5ify9)
# image elliotlarson/onehouse-website:production could not be accessed on a registry to record
# its digest. Each node will access elliotlarson/onehouse-website:production independently,
# possibly leading to different nodes running different
# versions of the image.

# Updating service ohweb_database (id: xcnoehy4a4fkkhsqshn057gnf)
# Updating service ohweb_db-creator (id: nc51jo15tv1iw9jugo4l10uqu)
# Updating service ohweb_db-migrator (id: jg9q09rseu3r3zcn26f16x55m)
```

## Volumes as a part of a stack

https://docs.docker.com/compose/compose-file/#volumes-for-services-swarms-and-stack-files

> If you want your data to persist, use a named volume and a volume driver that is multi-host aware, so that the data is accessible from any node

What is a volume driver?
