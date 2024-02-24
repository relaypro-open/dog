<p align="center">
  <img src="../../images/dog-segmented-green.network-200x200.png">
</p>

<h1>dog_agent</h1>

dog_agent is the client agent component of [dog](https://github.com/relaypro-open/dog),
a centralized firewall management system.

- [Runtime Dependencies](#runtime-dependencies)
- [Runtime Dependencies Setup](#runtime-dependencies-setup)
- [Build Dependencies](#build-dependencies)
- [Certificate Creation](#certificate-creation)
- [Deploy Configuration](#deploy-configuration)
- [Build Release Deploy](#build-release-deploy)
- [Deploy](#deploy)
- [Run](#run)
- [Logs](#logs)

## Runtime Dependencies

- linux 4.x+ (Ubuntu 22.04 tested)
- iptables
- ipset
- Only supports cloud public IP addresses on AWS EC2.

## Runtime Dependencies Setup

- Ubuntu:

```bash
apt install iptables
apt install iptables-persistent
apt install ipset
#install https://github.com/jordanrinke/ipsets-persistent plugin
sudo echo "dog     ALL=NOPASSWD: /sbin/ipset, /sbin/iptables-save, /sbin/iptables-restore , /sbin/ip6tables-save, /sbin/ip6tables-restore" > /etc/sudoers.d/dog
```
- Create 'dog' user:

```bash
mkdir /var/log/dog
chown dog: /var/log/dog
mkdir /var/db/dog
chown dog: /var/db/dog
mkdir /tmp/dog
chown dog: /tmp/dog
mkdir /tmp/erl_pipes
chown dog: /tmp/erl_pipes
```

## Build Dependencies

- erlang 24

## Certificate Creation

Each agent must have its own unique client certificate to connect to rabbitmq.

Create client certs to connect to the rabbitmq broker.  One option to get you started is: https://github.com/relaypro-open/csc

## Install

### Use github Release archive

github.com builds releases for Ubuntu x86

Download latest release archive:
https://github.com/relaypro-open/dog/releases

Extract archive to /opt/dog/

Create configuration file /etc/dog/dog.config, based on this template:

```erlang
[{dog,[{enforcing,true},{use_ipsets,true},{version,"public"}]},
 {kernel,[{inet_dist_use_interface,{127,0,0,1}}]},
 {lager,
     [{handlers,
          [{lager_console_backend,[{level,info}]},
           {lager_file_backend,
               [{file,"/var/log/dog/error.log"},{level,error}]},
           {lager_file_backend,
               [{file,"/var/log/dog/console.log"},{level,info}]}]},
      {crash_log,"/var/log/dog/crash.log"},
      {tracefiles,[]},
      {async_threshold,10000},
      {sieve_threshold,5000},
      {sieve_window,100},
      {colored,true}]},
 {sync,
     [{growl,none},
      {log,[all]},
      {non_descendants,fix},
      {executable,auto},
      {whitelisted_modules,[]},
      {excluded_modules,[]}]},
 {thumper,
     [{substitution_rules,
          [{fqdn,{dog_interfaces,fqdn,[]}},
           {environment,{dog_config,environment,[]}},
           {location,{dog_config,location,[]}},
           {group,{dog_config,group,[]}},
           {hostkey,{dog_config,hostkey,[]}}]},
      {thumper_svrs,[default,publish]},
      {brokers,
          [{default,
               [{rabbitmq_config,
                    [{host,"DOG_RABBITMQ_HOST"},
                     {port,5673},
                     {api_port,15672},
                     {virtual_host,<<"dog">>},
                     {user,<<"dog">>},
                     {password,<<"PASSWORD">>},
                     {ssl_options,
                         [{cacertfile,"/var/consul/data/pki/certs/ca.crt"},
                          {certfile,"/var/consul/data/pki/certs/server.crt"},
                          {keyfile,"/var/consul/data/pki/private/server.key"},
                          {verify,verify_peer},
                          {server_name_indication,disable},
                          {fail_if_no_peer_cert,true}]},
                     {broker_config,
                         {thumper_tx,
                             {callback,{dog_config,broker_config,[]}}}}]}]},
           {publish,[{rabbitmq_config,default}]}]},
      {queuejournal,
          [{enabled,false},
           {dir,"/opt/dog/queuejournal"},
           {memqueue_max,10000},
           {check_journal,true}]}]}].
```

Create /etc/dog/config.json based on this template:

```json
{"environment":"*","group":"DOG_GROUP","hostkey":"UNIQUE_HOST_KEY","location":"*"}
```

### Build Release Deploy

```$ rebar as $ENV tar```

copy tar to system, extract to /opt/dog_trainer

## Deploy

```bash
#update version metadata:
vim -o config/$ENV.sys.config src/dog.app.src rebar.config
$ ./rebar3 as $ENV tar

sudo mkdir /opt/dog.$VERSION
cd /opt/dog.$VERSION
sudo tar xf dog.$VERSION.tar.gz
sudo chown -R dog: /opt/dog.$VERSION
sudo rm /opt/dog
sudo ln -s dog.$VERSION /opt/dog
```

### Run

- Systemd(Ubuntu+)

```bash
cp config/dog.service /lib/systemd/system/dog.service
systemctl enable dog
systemctl start dog
```

### Logs

```/var/log/dog/```
