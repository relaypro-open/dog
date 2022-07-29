<p align="center">
  <img src="../../images/dog-segmented-green.network-200x200.png">
</p>

<h1>dog_on_a_dock</h1>

dog_on_a_dock is a complete dog test/dev environment implemented docker containers via
docker compose
It's meant to provide a way to test changes to dog in a full environment built
from scratch, as well as a way to easily try out dog.

---
  

- dog-server: hosts dog_trainer, dog_park, rethinkdb, and rabbitmq
- app-server: runs nginx, dog_agent
- db-server: runs postgresql, dog_agent

## Build/Install

[Docker Compose](https://github.com/docker/compose) is used to create multiple Docker containers.

One a Core i7 7thGen Laptop and a fast internet connection, this build took 35
minutes to build.

### MacOS/Windows/Linux Dependencies

If you are OK with the License requires, you can use Docker Desktop

- install [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### Open Source Dependencies

There are multiple ways to install the OS versions of Docker/Compose

### Build

This will clone repos, build and start all dog containers:

```bash
git clone https://github.com/relaypro-open/dog.git
cd dog

./dog_on_a_dock.sh
```

# Verify

`docker container ls` shoule output something similar to this:

```
CONTAINER ID   IMAGE                 COMMAND                  CREATED        STATUS         PORTS                                                                                                           NAMES
7fdbde882a5c   dog_dog_agent         "/opt/dog/bin/dog fo…"   41 hours ago   Up 6 minutes   22/tcp, 0.0.0.0:2222->2222/tcp, :::2222->2222/tcp                                                               dog_agent
00c6fd63e024   dog_dog_park          "/docker-entrypoint.…"   2 days ago     Up 6 minutes   80/tcp, 0.0.0.0:3030->3030/tcp, :::3030->3030/tcp                                                               dog_park
f78dfd8fd92c   dog_dog_trainer       "/opt/dog_trainer/bi…"   2 days ago     Up 6 minutes   0.0.0.0:7070->7070/tcp, :::7070->7070/tcp                                                                       dog_trainer
5eb167636243   rabbitmq:management   "docker-entrypoint.s…"   3 days ago     Up 6 minutes   4369/tcp, 5671-5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp, :::15672->15672/tcp   rabbitmq
c63a16687fec   jwilder/nginx-proxy   "/app/docker-entrypo…"   3 days ago     Up 6 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp                                                                               dog_nginx_proxy
5793902c06dc   rethinkdb             "rethinkdb --bind all"   3 days ago     Up 6 minutes   28015/tcp, 0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 29015/tcp                                                 rethinkdb
```

# Use

## dog alias
You must create an alias for localhost called 'dog' for the dog_park gui to work

/etc/hosts:
127.0.0.1	localhost dog

## Web consoles
Docker is configured to forward the containers' service to the physical hosts'
localhost ports

- dog_park gui [http://dog:80](http://dog:80)

- rethinkdb [http://localhost:8080](http://localhost:8080)

- rabbitmq [http://localhost:15672](http://localhost:15672)

## Agent Test

1) Go to the dog_park gui: http://dog.
2) Create a Service called 'ssh' with TCP port 22.
3) Create a Profile called 'dog_test" with a rule allowing 'All' to 'ALLOW' the service 'ssh'.
4) Create a Group called 'local_group' (This is the default group in the Docker configuration).
5) Ensure the Host 'docker-node-123' is in the Group 'local_group' (The default name of the agent in the Docker configuration).

### Check agent iptables and ipsets

`docker exec -t -i dog_agent "/usr/sbin/iptables-save"`
should return something like:

```
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -i lo -m comment --comment "local any" -j ACCEPT
-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A INPUT -j DROP
-A FORWARD -j REJECT --reject-with icmp-port-unreachable
-A OUTPUT -o lo -m state --state RELATED,ESTABLISHED -m comment --comment "local any" -j ACCEPT
-A OUTPUT -p tcp -m tcp --sport 22 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -j ACCEPT
COMMIT
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
```

`docker exec -t -i dog_agent "bash"
`> /sbin/ipset save`

should output something like:

```
create all-active_gv4 hash:net family inet hashsize 1024 maxelem 65536
add all-active_gv4 172.25.0.7
create local_group_gv4 hash:net family inet hashsize 1024 maxelem 65536
add local_group_gv4 172.25.0.7
create all-active_gv6 hash:net family inet6 hashsize 1024 maxelem 65536
create local_group_gv6 hash:net family inet6 hashsize 1024 maxelem 65536
root@7fdbde882a5c:/data# bash -c '/sbin/ipset save'
create all-active_gv4 hash:net family inet hashsize 1024 maxelem 65536
add all-active_gv4 172.25.0.7
create local_group_gv4 hash:net family inet hashsize 1024 maxelem 65536
add local_group_gv4 172.25.0.7
create all-active_gv6 hash:net family inet6 hashsize 1024 maxelem 65536
create local_group_gv6 hash:net family inet6 hashsize 1024 maxelem 65536
```
