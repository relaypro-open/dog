<p align="center">
  <img src="../../images/dog-segmented-green.network-200x200.png">
</p>

<h1>dog_trainer</h1>

dog_trainer is the central server component of [dog](https://github.com/relaypro-open/dog),
a centralized firewall management system.

- [Runtime Dependencies](#runtime-dependencies)
- [Build Dependencies](#build-dependencies)
- [Certificate Creation](#certificate-creation)
- [RethinkDB setup](#rethinkdb-setup)
- [RabbitMQ setup](#rabbitmq-setup)
- [App setup](#app-setup)
- [Build Release Deploy](#build-release-deploy)
- [Run](#run)
- [Logs](#logs)
- [Deploy Agents](#deploy-agents)

## Runtime Dependencies

- linux 4.x+ (Ubuntu 22.04 tested)
- diffutils
- coreutils
- rabbitmq-server 3.7+
- rethinkdb 2.3.6+
- git

## Build Dependencies

- erlang 24

### Certificate Creation

If you already have a CA and per-server certs, you can reuse them, or buy new ones
(costly).
You can create your own self-signed certs with your own Certificate Authority.

One option to get you started is: https://github.com/relaypro-open/csc

### RethinkDB setup

#### Install RethinkDB

```bash
sudo apt install rethinkdb=2.3.6~0xenial
```

#### Setup clustering

For high availability, setup replication: [sharding-and-replication](https://rethinkdb.com/docs/sharding-and-replication/)

#### RethinkDB security

RethinkDB's web console doesn't require authentication,
but you can use oauth2_proxy [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy)
for that purpose.

#### Create database tables and indexes

Automatically created on dog_trainer start.

#### Import default Services

Definitions for some well known services can be imported.

```bash
rethinkdb import -f /opt/dog_trainer/scripts/default_services.json --table dog.service
```

### RabbitMQ setup

#### install RabbitMQ

      sudo apt install rabbitmq-server=3.7.17-1

#### Copy and edit config

```bash
cp config/rabbitmq/rabbitmq.conf /etc/rabbitmq/
#edit rabbitmq to reflect location of certs and 
#you should replace PRIVATE_IP with an IP that is not accessible via the
#pubilc internet.
cp config/rabbitmq/enabled_plugins /etc/rabbitmq/
restart rabbitmq-server
```

#### Create virtual host and admin users

```bash
#edit setup_rabbitmq.sh, define variables.
script/setup_rabbitmq.sh
```

### Networking

#### Create DNS service names

It's useful to create service names for the dog_trainer clients to connect to.  
You may want to create one for each type of connection:

- rabbitmq clients: To force rabbitmq connections over private networks in EC2,
create this service name as a A Record with the private IP of your server as its
value.
- dog_park (gui) clients

#### Federate multiple brokers to connect to multiple regions

You can deploy multiple rabbitmq servers across regions, using the federation
plugin to replcate client queues
and exchanges.  You can then connect your agents to these distributed rabbitmqs
via their local private IPs,
avoiding having to have agents connect to a rabbitmq in another region across
the public internet.
[RabbitMQ federation](https://www.rabbitmq.com/federation.html)  



## Install 

Create directories:

```bash
./install.sh
```

### Use github Release archive

github.com builds releases for Ubuntu x86

Download latest release archive:
https://github.com/relaypro-open/dog_trainer/releases

Extract archive to /opt/dog_trainer/

Create configuration file /etc/dog_trainer/dog_trainer.config, based on this template:

{% raw %}
```erlang
[
    {dog_trainer, [
        {keepalive_alert_seconds, 60}
        ]},
    {sync, [
        {growl, none},
        {log, [warnings, errors]},
        {non_descendants, fix},
        {executable, auto},
        {whitelisted_modules, []},
        {excluded_modules, []}
    ]},
    {lager, [
        {handlers, [
            {lager_console_backend, 
        	[none,
        	   {lager_default_formatter, [time, 
        		" [", severity, "] ", pid, " (", {turbine_id, "non-turbine"}, ") ==> ", message, "\n"]}]},
            {{lager_file_backend, "error_log"}, [{file, "/var/log/dog_trainer/error.log"}, {level, error}]},
            {{lager_file_backend, "console_log"}, [{file, "/var/log/dog_trainer/console.log"}, {level, info }]}
        ]},
        {crash_log, "/var/log/dog_trainer/crash.log"},
        {tracefiles, [
        	   ]},
        {async_threshold, 10000},
        {sieve_threshold, 5000},
        {sieve_window, 100}
    ]},
    {thumper, [
        {substitution_rules, []},
        {thumper_svrs, [default, publish]},
        {brokers, [
            {default, [
                {rabbitmq_config,
                    [
                        {host, "DOG_RABBITMQ_HOST"},
                        {port, 5673},
                        {api_port, 15672},
                        {virtual_host, <<"dog">>},
                        {user, <<"dog_trainer">>},
                        {password, <<"PASSWORD">>},
                        {ssl_options, [{cacertfile, "/opt/dog_trainer/priv/certs/rabbitmq/ca/cacert.pem"},
                                       {certfile, "/opt/dog_trainer/priv/certs/rabbitmq/client/cert.pem"},
                                       {keyfile, "/opt/dog_trainer/priv/certs/rabbitmq/client/key.pem"},
                                       {verify, verify_none},
                                       {fail_if_no_peer_cert, true}
                                      ]},
                         {broker_config,
                             {thumper_tx,
                                 ["/opt/dog_trainer/priv/broker.tx"]}}
                    ]}]},
            {publish, [{rabbitmq_config, default}]}
        ]},
        {queuejournal,
            [
                {enabled, true},
                {dir, "/var/db/dog_trainer/queuejournal"},
                {memqueue_max, 10000},
                {check_journal, true}
            ]
        }
    ]},
    {erlcloud, [
      {aws_config, [
          {ec2_host, "ec2.us-east-1.amazonaws.com"}
      ]}
    ]}
].
```
{% endraw %}


### Build Release Deploy

```bash
$ rebar as $ENV tar

#copy tar to system, extract to /opt/dog_trainer
```

## Run

Setup systemd service

```bash
cp config/dog_trainer.service /lib/systemd/system/dog_trainer.service
systemctl enable dog_trainer
systemctl start dog_trainer
```

## Logs

```bash
/var/log/dog_trainer/
```

## Deploy Agents

  [Agents](https://github.com/relaypro-open/dog_agent)
