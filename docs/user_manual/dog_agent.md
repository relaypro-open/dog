<p align="center">
  <img src="../../images/dog-segmented-green.network-200x200.png">
</p>

# dog_agent

dog_agent is the component of dog that runs on each server, controlling its firewall.

## Start

`sudo systemctl start dog`

## Stop

`sudo systemctl stop dog`

## Log location

`/var/log/dog`

## Configuration files

Located in `/etc/dog/`

If you create config.json before you connect to dog_trainer, dog_trainer will
create the host and assign it to the group specified.

config.json: configuration file

example:

```bash
      {
      "environment":"*", # currently unused
      "group":"opengrok_qa", # dog group the host is assigned to
      "hostkey":"2cf5115b7720132b40bd37cef9021f4782e2f7d1", # unique key for agent, the sha256sum of agent's public key.
      "location":"*" # currenlty unused
      }
```

The remainder are temp files, useful for debugging: 

```bash
    ipset.txt # global ipsets

    # iptables files as received from dog_trainer:
     ip6tables_iptables.txt 
     ip6tables_ipsets.txt
     ip4tables_iptables.txt
     ip4tables_ipsets.txt

     iptables.txt # IPv4 iptables that is applied
     iptables.back # previous IPv4 iptables
     ip6tables.txt # IPv6 iptables that is applied
     ip6tables.back # previous IPv6 iptables

    # iptables files generated locally by dog_agent for Docker support:
     iptables-docker.txt
     iptables-docker-trainer-filter.txt
     iptables-docker-nat.txt
     iptables-docker-filter.txt
```

## Erlang console access

Console access is disabled in dog_agent

## Scripts

located in `/opt/dog/scripts/`

- hashes.escript: displays hashes of local temp files

  example output:

```bash
    config.json:
    {"environment":"*","group":"opengrok_qa","hostkey":"2cf5115b7720132b40bd37cef9021f4782e2f7d1","location":"*"}
    
    Source:                  Hash:
    iptables-save:           60b4c165710bfdcdbf053dd16ae55df7d6a6999955090b4eae7c4ff2e6b1ed2f
    ipv4tables_ipsets.txt:   60b4c165710bfdcdbf053dd16ae55df7d6a6999955090b4eae7c4ff2e6b1ed2f
    ipv4tables_iptables.txt: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
    
    ip6tables-save:          ef581056117c8c0c67b40f36a5cab3de2472c6cf6ddc1314706c2f94e557492c
    ipv6tables_ipsets.txt:   ef581056117c8c0c67b40f36a5cab3de2472c6cf6ddc1314706c2f94e557492c
    ipv6tables_iptables.txt: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
    
    ipset save:              b7a27a39fe4a75f87bd5e49f623529f092edc8de3abe23d912599fdf55270a03
    ipset.txt:               b7a27a39fe4a75f87bd5e49f623529f092edc8de3abe23d912599fdf55270a03
```

## Capabilities

Originally dog_agent used sudo rights.  To better limit what rights dog_agent has,
Linux [capabilities](https://blog.container-solutions.com/linux-capabilities-why-they-exist-and-how-they-work)
are used instead.  For systems with systemd, those capabilities are granted to
the process via the service file definition

dog.service

```bash
    ...
    [Service]
        CapabilityBoundingSet=CAP_DAC_READ_SEARCH CAP_NET_ADMIN CAP_NET_RAW
        AmbientCapabilities=CAP_DAC_READ_SEARCH CAP_NET_ADMIN CAP_NET_RAW
    ...
```

For systems without systemd, those capabilities are granted to special binaries
available only to the dog user.

```bash
    $ getcap /home/dog/bin/*
    ip6tables-restore = cap_dac_read_search,cap_net_admin,cap_net_raw+ep
    ip6tables-save = cap_dac_read_search,cap_net_admin,cap_net_raw+ep
    ipset = cap_net_admin,cap_net_raw+ep
    iptables-restore = cap_dac_read_search,cap_net_admin,cap_net_raw+ep
    iptables-save = cap_dac_read_search,cap_net_admin,cap_net_raw+ep
```

Both systemd and systemd-less systems use the /home/bin/dog/\* binaries, but the
systemd system doesn't have file based capabilities set.

## Config file

Configuration is stored in a file called sys.config, which is located in
/opt/dog/releases/$VERSION/

example sys.config, annotated:

```bash
    [
    {kernel,[{inet_dist_use_interface,{127,0,0,1}}]},
    {dog, [
        {version, ""}, # git version
        {enforcing, true}, # whether dog applies its rules or not.
        {use_ipsets, true}, # whether to use ipsets version of iptables rules.
        {watch_interfaces_poll_seconds, 5}, # how often to poll interfaces for changes.
        {keepalive_poll_seconds, 60} # how often to send a keepalive message to dog_trainer.
    ]},
    {sync, [
        {growl, none},
        {log, [all]},
        {non_descendants, fix},
        {executable, auto},
        {whitelisted_modules, []},
        {excluded_modules, []}
    ]},
    {lager, [
        {handlers, [ # log levels and locations
            {lager_console_backend, [{level, error}]},
            {lager_file_backend, [{file, "/var/log/dog/error.log"}, {level, error}]},
            {lager_file_backend, [{file, "/var/log/dog/console.log"}, {level, info }]}
        ]},
        {crash_log, "/var/log/dog/crash.log"},
        {tracefiles, [
                    ]},
        {async_threshold, 10000},
        {sieve_threshold, 5000},
        {sieve_window, 100},
        {colored, true}
    ]},
    {thumper, [
        {substitution_rules,[
           {fqdn, {dog_interfaces,fqdn,[]}},
           {environment, {dog_config,environment,[]}},
           {location, {dog_config,location,[]}},
           {group, {dog_config,group,[]}},
           {hostkey, {dog_config,hostkey,[]}}
        ]},
        {thumper_svrs, [default, publish]},
        {brokers, [
            {default, [
                {rabbitmq_config, # rabbitmq connection configuration
                   [
                        {host, ""},
                        {port, 5673},
                        {api_port, 15672},
                        {virtual_host, <<"dog">>},
                        {user, <<"dog">>},
                        {password, <<"">>},
                        {ssl_options, [{cacertfile, "/var/consul/data/pki/certs/ca.crt"},
                                       {certfile, "/var/consul/data/pki/certs/server.crt"},
                                       {keyfile, "/var/consul/data/pki/private/server.key"},
                                       {verify, verify_peer},
                                       {server_name_indication, disable},
                                       {fail_if_no_peer_cert, true}
                                      ]},
                     {broker_config,
                        {thumper_tx, {callback, {dog_config, broker_config, []}}}
                     }
                    ]}]},
            {publish, [{rabbitmq_config, default}]}
        ]},
        {queuejournal,
            [
                {enabled, false}, # we don't want local queue caching; that would dump old data to dog_trainer on reconnect.
                {dir, "/opt/dog/queuejournal"},
                {memqueue_max, 10000},
                {check_journal, true}
            ]
        }
    ]},
    {erldocker, [ # Docker socket
        {docker_http, <<"http+unix://%2Fvar%2Frun%2Fdocker.sock">>}
    ]}
].
```
