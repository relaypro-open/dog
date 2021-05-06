<p align="center">
  <img src="../../images/dog-segmented-green.network-200x200.png">
</p>

# dog_agent

dog_agent is the component of dog that runs on each server, controlling it's firewall.

- start: `sudo systemctl start dog`

- stop: `sudo systemctl stop dog`

- log location: `/var/log/dog`

- configuration files: `/etc/dog/`

    If you create config.json before you connect to dog_trainer, dog_trainer will
    create the host and assign it to the group specified.\

    config.json: configuration file

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

- scripts in `/opt/dog/scripts/`

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

