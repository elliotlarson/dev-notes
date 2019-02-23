# Docker Swarm Notes

Swarm is a container orchestration framework.  It handles creating a network and bringing up container across a series of hosts/nodes.

## Check if Swarm is enabled

```bash
$ docker info | grep Swarm
# if it's not enabled
# => Swarm: inactive
# if it's enabled
# => Swarm: active
```

## Enable Swarm

```bash
$ docker swarm init
# Swarm initialized: current node (7v2wlaljlfumj9keuw3opxjc7) is now a manager.
#
# To add a worker to this swarm, run the following command:
#
#     docker swarm join --token SWMTKN-1-3xq68hwg60xfigzsnbx2qhel6jpirf6pzvqpmss2xx54aoh5pi-763xowura116eykki60453hfg 192.168.65.3:2377
#
# To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

## Run a command on a service image

```bash
$ docker service create alpine ping 8.8.8.8
# qg2ivwufif1nzzg5k54wbew7e
```

This outputs the ID of the service

## See what services are running

```bash
$ docker service ls
# ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
# qg2ivwufif1n        sad_poincare        replicated          1/1                 alpine:latest
```

## See the containers running for a service

```bash
$ docker service ps sad_poincare
# ID                  NAME                IMAGE               NODE                    DESIRED STATE       CURRENT STATE           ERROR               PORTS
# v0pw5a8plw3t        sad_poincare.1      alpine:latest       linuxkit-025000000001   Running             Running 5 minutes ago
```

You can also look at the containers directly. Notice how the name is augmented to include the service name and replica number.

```bash
$ docker container ls
# CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
# 3826f800d56e        alpine:latest       "ping 8.8.8.8"      5 minutes ago       Up 5 minutes                            sad_poincare.1.v0pw5a8plw3torc0mygpfsuow
```

## Change number of replicas for a service

```bash
$ docker service update qg2ivwufif1n --replicas 3
# qg2ivwufif1n
# overall progress: 3 out of 3 tasks
# 1/3: running   [==================================================>]
# 2/3: running   [==================================================>]
# 3/3: running   [==================================================>]
# verify: Service converged

$ docker service ls
# ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
# qg2ivwufif1n        sad_poincare        replicated          3/3                 alpine:latest

$ docker service ps sad_poincare
# ID                  NAME                IMAGE               NODE                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
# v0pw5a8plw3t        sad_poincare.1      alpine:latest       linuxkit-025000000001   Running             Running 13 minutes ago
# rswiwj2yupzp        sad_poincare.2      alpine:latest       linuxkit-025000000001   Running             Running 3 minutes ago
# wo6yva0hs936        sad_poincare.3      alpine:latest       linuxkit-025000000001   Running             Running 3 minutes ago
```

Notice after the update, the number of replicas is now set to 3.

## Swarm will bring back up a container if it goes down

If you remove one of the service containers manually, Swarm will bring it back up.

```bash
$ docker container ls
# CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
# 864b580b7f9f        alpine:latest       "ping 8.8.8.8"      11 minutes ago      Up 11 minutes                           sad_poincare.3.wo6yva0hs936zz5496rh4dlrh
# 331014cab26d        alpine:latest       "ping 8.8.8.8"      11 minutes ago      Up 11 minutes                           sad_poincare.2.rswiwj2yupzpg6fa98wyl2hhd
# 3826f800d56e        alpine:latest       "ping 8.8.8.8"      21 minutes ago      Up 21 minutes                           sad_poincare.1.v0pw5a8plw3torc0mygpfsuow

$ docker container rm -f 864b580b7f9f
# 864b580b7f9f

$ docker service ps sad_poincare
# ID                  NAME                 IMAGE               NODE                    DESIRED STATE       CURRENT STATE            ERROR                         PORTS
# v0pw5a8plw3t        sad_poincare.1       alpine:latest       linuxkit-025000000001   Running             Running 21 minutes ago
# rswiwj2yupzp        sad_poincare.2       alpine:latest       linuxkit-025000000001   Running             Running 11 minutes ago
# b3mbljpdpoyp        sad_poincare.3       alpine:latest       linuxkit-025000000001   Running             Running 1 second ago
# wo6yva0hs936         \_ sad_poincare.3   alpine:latest       linuxkit-025000000001   Shutdown            Failed 6 seconds ago     "task: non-zero exit (137)"
```

Notice that the ps command outputs history for the shutdown and restarted container `sad_poincare.3`.

## Remove a service

```bash
$ docker service rm sad_poincare
```

This removes the service and the related containers.

## Creating nodes with Docker machine

If you want to play with swarm locally, you can use the `docker-machine` command to create nodes with VirtualBox.

### Creating a node

```bash
$ docker-machine create node1
# Running pre-create checks...
# Creating machine...
# (node1) Copying /Users/Elliot/.docker/machine/cache/boot2docker.iso to /Users/Elliot/.docker/machine/machines/node1/boot2docker.iso...
# (node1) Creating VirtualBox VM...
# (node1) Creating SSH key...
# (node1) Starting the VM...
# (node1) Check network to re-create if needed...
# (node1) Waiting for an IP...
# Waiting for machine to be running, this may take a few minutes...
# Detecting operating system of created instance...
# Waiting for SSH to be available...
# Detecting the provisioner...
# Provisioning with boot2docker...
# Copying certs to the local machine directory...
# Copying certs to the remote machine...
# Setting Docker configuration on the remote daemon...
# Checking connection to Docker...
# Docker is up and running!
# To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env node1
```

### List nodes

Assuming you've created 3 nodes.

```bash
$ docker-machine ls
# NAME    ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER     ERRORS
# node1   -        virtualbox   Running   tcp://192.168.99.103:2376           v18.09.1
# node2   -        virtualbox   Running   tcp://192.168.99.104:2376           v18.09.1
# node3   -        virtualbox   Running   tcp://192.168.99.105:2376           v18.09.1
```

### Remove a node

```bash
$ docker-machine rm node1
```

### SSH into a node

```bash
$ docker-machine ssh node1
```

### Get information about a node

```bash
$ docker-machine env node1
# export DOCKER_TLS_VERIFY="1"
# export DOCKER_HOST="tcp://192.168.99.103:2376"
# export DOCKER_CERT_PATH="/Users/Elliot/.docker/machine/machines/node1"
# export DOCKER_MACHINE_NAME="node1"
# # Run this command to configure your shell:
# # eval $(docker-machine env node1)
```

You can also run the following command which sets the above environment variables in the current shell causing the docker commands to point to the `node1` node:

```bash
$ eval $(docker-machine env node1)
```

To unset this:

```bash
$ eval $(docker-machine evn -u)
```

### Create a swarm

Create the first swarm manager on node1

```bash
$ docker-machine ssh node1
node1> $ docker swarm init
# get manager join token command for the other nodes
node1> $ docker swarm join-token manager
# To add a manager to this swarm, run the following command:
#
#     docker swarm join --token SWMTKN-1-4mm6iio54sj78z3f87og30e3ygrzrijy9iqciyp7drsqolsghm-6hy6fefvtzr6f0dn8k9704zpu 192.168.99.106:2377
```

Add node2 and node3 as manager nodes in the swarm:

```bash
$ docker-machine ssh node2
node2> $ docker swarm join --token SWMTKN-1-4mm6iio54sj78z3f87og30e3ygrzrijy9iqciyp7drsqolsghm-6hy6fefvtzr6f0dn8k9704zpu 192.168.99.106:2377
node2> $ exit
$ docker-machine ssh node3
node3> $ docker swarm join --token SWMTKN-1-4mm6iio54sj78z3f87og30e3ygrzrijy9iqciyp7drsqolsghm-6hy6fefvtzr6f0dn8k9704zpu 192.168.99.106:2377
node3> exit
```

Start a service on the swarm:

```bash
$ docker-machine ssh node1
node1> $ docker service create --replicas 3 alpine ping 8.8.8.8
```

### Stopping a docker-machine node

This will gracefully stop the VM:

```bash
$ docker-machine stop node1
```

### Restarting a stopped docker-machine node

```bash
$ docker-machine start node1
```

### Removing a docker-machine

```bash
$ docker-machine rm node1
```

## Creating a server on a VPS provider

If you're creating VPSs to host the swarm, you need to install Docker:

```bash
# ssh into server
$ curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
```

### Create a swarm

log into node 1 and initalize the swarm:

```bash
# using the public IP of the server (should this be the private local IP instead?)
node1> $ docker swarm init --advertise-addr 157.230.152.10
# Swarm initialized: current node (mm3ph4phd9owg3wn8d0my9rj6) is now a manager.
#
# To add a worker to this swarm, run the following command:
#
#     docker swarm join --token SWMTKN-1-4avreivdahazi6mqxgswtxdvlzr2cqhk23x0cricza1usbcxva-c1x9e5xjb7epv16wy5pnu7wkl 157.230.152.10:2377
#
# To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Then log into the other servers/nodes and add the join command:

```bash
node2> $ docker swarm join --token SWMTKN-1-4avreivdahazi6mqxgswtxdvlzr2cqhk23x0cricza1usbcxva-c1x9e5xjb7epv16wy5pnu7wkl 157.230.152.10:2377
node3> $ docker swarm join --token SWMTKN-1-4avreivdahazi6mqxgswtxdvlzr2cqhk23x0cricza1usbcxva-c1x9e5xjb7epv16wy5pnu7wkl 157.230.152.10:2377
```

Then on node 1, you can list out the nodes in the swarm:

```bash
node1> $ docker node ls
# ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
# mm3ph4phd9owg3wn8d0my9rj6 *   node1               Ready               Active              Leader              18.09.1
# 5mmqipd3k3qqstm7etqb6irxo     node2               Ready               Active                                  18.09.1
# gfh833f1lewdkzek0i06myxdm     node3               Ready               Active                                  18.09.1
```

Notice that node1 is the leader.

You can have multiple leaders.  To migrate node2 to a leader:

```bash
node1> $ docker node update --role manager node2
```

Now lets create a new service to run a process and replicate it 3 times:

```bash
node1> $ docker service create --replicas 3 alpine ping 8.8.8.8
# st83v3oy9agngbpgrwkfl2x96
# overall progress: 3 out of 3 tasks
# 1/3: running   [==================================================>]
# 2/3: running   [==================================================>]
# 3/3: running   [==================================================>]
# verify: Service converged

node1> $ docker service ls
# ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
# st83v3oy9agn        blissful_davinci    replicated          3/3                 alpine:latest

node1> $ docker service ps blissful_davinci
# ID                  NAME                 IMAGE               NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
# oytfv72hzo0z        blissful_davinci.1   alpine:latest       node3               Running             Running 58 seconds ago
# wopizygovj0a        blissful_davinci.2   alpine:latest       node1               Running             Running 57 seconds ago
# gfra5nvh7r4r        blissful_davinci.3   alpine:latest       node2               Running             Running 57 seconds ago
```

Notice that it spread the service containers across the 3 available nodes.

## Deploying

```bash
# Build image
$ docker build -f Dockerfile.production -t elliotlarson/onehouse-website:production .
$ docker push elliotlarson/onehouse-website:production
$ eval($docker-machine env ohweb)

# Deploy to the swarm
$ docker stack deploy --with-registry-auth -c docker-stack.yml ohweb
```

### See if stuff worked

```bash
$ docker service ls
# ID                  NAME                MODE                REPLICAS            IMAGE                                      PORTS
# 9ffl0bmlyh9a        rtest_database      replicated          1/1                 postgres:11.1-alpine
# jzpb3277447w        rtest_db-creator    replicated          0/1                 elliotlarson/myapp_web:prod
# tm8telxthliq        rtest_db-migrator   replicated          0/1                 elliotlarson/myapp_web:prod
# zk83eabezdv6        rtest_web           replicated          1/1                 elliotlarson/onehouse-website:production   *:80->3000/tcp
$ docker service ps ohweb_web
# ID                  NAME                IMAGE                                      NODE                DESIRED STATE       CURRENT STATE             ERROR                       PORTS
# ed2k9qzn6j3x        rtest_web.1         elliotlarson/onehouse-website:production   rtest               Running             Running 2 minutes ago
# axrycw0uadax         \_ rtest_web.1     elliotlarson/onehouse-website:production   rtest               Shutdown            Shutdown 2 minutes ago
# 7h7uoy7fjptd         \_ rtest_web.1     elliotlarson/onehouse-website:production   rtest               Shutdown            Shutdown 14 minutes ago
# oc1gb5iego9z         \_ rtest_web.1     elliotlarson/onehouse-website:production   rtest               Shutdown            Failed 14 minutes ago     "task: non-zero exit (1)"
# ngyu5rmw9zdx         \_ rtest_web.1     elliotlarson/onehouse-website:production   rtest               Shutdown            Failed 14 minutes ago     "task: non-zero exit (1)"
$ docker service logs ohweb_web

# Once happy undo the env var setting
$ eval $(docker-machine env -u)
```

### Troubleshooting

```bash
# Make sure you have the env vars set so you talk to the server with Docker commands
$ eval($docker-machine env ohweb)
```

#### View the service logs

```bash
# See what services are running
$ docker service ps
# ID                  NAME                MODE                REPLICAS            IMAGE                                      PORTS
# iubo5lg3z5lx        rtest_app           replicated          1/1                 elliotlarson/onehouse-website:production   *:80->3000/tcp
# wolxt036jpxi        rtest_database      replicated          1/1                 postgres:11.1-alpine
# 5csm97zz4ifh        rtest_db-creator    replicated          0/1                 elliotlarson/onehouse-website:production
# idtgsg3apftb        rtest_db-migrator   replicated          0/1                 elliotlarson/onehouse-website:production

# Checkout the logs for a service
$ docker service logs rtest_app
```

#### Log into the container

```bash
# See what containers are running
$ docker container ps
# CONTAINER ID        IMAGE                                      COMMAND                  CREATED             STATUS              PORTS               NAMES
# 7fb12e44f183        elliotlarson/onehouse-website:production   "bin/rails s -b 0.0.…"   2 minutes ago       Up 2 minutes                            rtest_app.1.pu4h2tflon9jj9kcjbsqj74c9
# 06fc7a7124e8        postgres:11.1-alpine                       "docker-entrypoint.s…"   19 minutes ago      Up 19 minutes       5432/tcp            rtest_database.1.yrv0bgfzqr57frwn3ogm9okht

# Log into the container
$ docker exec -it rtest_app.1.pu4h2tflon9jj9kcjbsqj74c9 sh
```

#### Hop on the Rails console

```bash
# Get a list of the containers
$ docker container ls
# CONTAINER ID        IMAGE                                      COMMAND                  CREATED             STATUS              PORTS               NAMES
# 95c853b76ca2        elliotlarson/onehouse-website:production   "bin/rails s -b 0.0.…"   5 minutes ago       Up 5 minutes                            rtest_app.1.h3smda9yk95u0w8adkyrbv2cc
# 06fc7a7124e8        postgres:11.1-alpine                       "docker-entrypoint.s…"   42 minutes ago      Up 42 minutes       5432/tcp            rtest_database.1.yrv0bgfzqr57frwn3ogm9okht

# Get on the Rail console
$ docker exec -it rtest_app.1.h3smda9yk95u0w8adkyrbv2cc rails c
```
