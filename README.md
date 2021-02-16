<p align="center">
  <img src="images/dog-segmented-green.network-400x400.png">
</p>

1. [What is dog?](#what-is-dog?)
2. [Why dog?](#why-dog?)
3. [Features](#features)
4. [Components](#components)
5. [Architecture](#architecture)
6. [Security](#security)
7. [Logical Elements](#logical-elements)
8. [Install](#install)

## What is dog?
dog is a firewall management system designed to manage hundreds+ of servers.

Think of it as your guard dog.

## Why dog?
- Need consistent network access rules across hundreds+ of servers in multiple regions on multiple providers?
- Need defense-in-depth, beyond gateway firewalls?
- Need blocklists with thousands of addresses distributed across many servers updated constantly?
- Need to limit number of connections and/or bandwidth usage?
- Sick of error-prone manual updates of per-server iptables?

## Features
- Centrally manage hundreds+ of per-server iptables firewalls.  
- Works across clouds, regions, and on-premise infrastructure.
- Adapts to dynamic address changes.
- Large blocklists/allowlists can be used and will be updated in seconds across all servers.
- Rules scale to tens of thousands of addresses (ipsets).
- Alerts if servers fail to communicate or if their firewalls are modified outside of dog control.
- Nice web interface.
- API for external integrations.
- Tested in production with hundreds of servers.
- Multiple dog_trainers can be federated together to allow sharing of addresses, 
  while allowing each dog_trainer to have it's own security rules.

## Components
- [dog_trainer](https://github.com/Phonebooth/dog_trainer) is a central server, used to configure and control dog agents.  
   Multiple dog_trainers can be federated together to allow sharing of agents' addresses, while allowing each dog_trainer to have it's own security rules.

- [dog agent](https://github.com/Phonebooth/dog_agent)s are deployed to all managed servers.  dog agents control the server's iptables firewalls.

- [dog_park](https://bitbucket.org/republicwireless/dog_park/src/master/) is the browser user interface for dog_trainer.

## Architecture
![dog](images/dog_family_overview_landscape-1.1.jpg)
- dog Agents communicate with dog_trainer over RabbitMQ queues.
- dog_trainer stores it's configuration in a RethinkDB database.
- dog_park communicates with dog_park via a RESTful API, which can be used for further integrations.

## Security
- Provides defense-in-depth, so you are not completely dependent on gateway firewalls.
- dog agents authenticate to RabbitMQ with per-agent client certificates, and all communication is encrypted.
- RabbitMQ should be configured to only communicate over private networks.
- Additional federated RabbitMQs can be configured to allow communication over regional boundaries.
- dog_trainer stores hashes of the iptables and ipsets it sends to agents.  Agents send their own generated hashes to dog_trainer via a scheduled check-in.
- dog_trainer will alert if agents fail to communicate over time or if the hashes the agents provide do not match what dog_trainer expects.
- dog's use of ipsets not only allows highly scalable, fast rulesets, it also keeps iptables size small enough to be auditable by a human.

## Logical Elements
- Hosts are servers with Agents installed.
- Zones are static lists of addresses.
- Groups are collections of Hosts.
- Profiles are lists of Rules, and are assigned to Groups.
- Rules can include either Groups or Zones along with Services that describe the controlled protocols.
- Iptables are generated from these Rules and distributed to Agents.
- Ipsets are used to make fast, readable iptables rules even with thousands of addresses.

- Links are used to share the addresses of Groups and Zones (as ipsets) between multiple dog_trainers.

## Install
- [dog_in_a _box](docs/dog__in_a__box.md)
- [dog_trainer](docs/dog_trainer.md)
- [dog_park](docs/dog_park.md)
- [dog_agent](docs/dog_agent.md)
