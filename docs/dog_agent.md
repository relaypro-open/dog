<p align="center">
  <img src="../images/dog-segmented-green.network-200x200.png">
</p>

<h1>dog_agent</h1>

dog_agent is the client agent component of [dog](https://github.com/Phonebooth/dog), a centralized firewall management system.

* [Runtime Dependencies](#runtime-dependencies)
* [Runtime Dependencies Setup](#runtime-dependencies-setup)
* [Build Dependencies](#build-dependencies)
* [Certificate Creation](#certificate-creation)
* [Deploy Configuration](#deploy-configuration)
* [Build Release](#build-release)
* [Deploy](#deploy)
* [Agent Configuration](#agent-configuration)
* [Run](#run)
* [Logs](#logs)

## Runtime Dependencies
- linux 4.x+ (CentOS 6, Ubuntu 16.04+ tested)
- iptables
- ipset

## Runtime Dependencies Setup

- Ubuntu:

        apt install iptables
        apt install iptables-persistent
        apt install ipset
        #install https://github.com/jordanrinke/ipsets-persistent plugin
        sudo echo "dog     ALL=NOPASSWD: /sbin/ipset, /sbin/iptables-save, /sbin/iptables-restore , /sbin/ip6tables-save, /sbin/ip6tables-restore" > /etc/sudoers.d/dog

- RedHat,CentOS:

        yum install iptables
        yum install iptables-ipv6
        yum install ipset
    
        #increase ip_set kernel module max_sets (defaults to 256 on CentOS 6):    
        iptables -F
        modprobe -r xt_set
        modprobe -r ip_set_hash_net
        modprobe -r ip_set
        echo 'options ip_set max_sets=8192' > /etc/modprobe.d/ip_set.conf
        modprobe ip_set
        modprobe ip_set_hash_net
        load xt_set
        modprobe xt_set

        #make filesytem match ubuntu:
        ln -s usr/sbin/ipset /sbin/ipset
        mkdir /etc/iptables
        ln -s /etc/iptables/rules.ipset /etc/sysconfig/ipset
        #sudo visudo, add this following line:
        dog     ALL=NOPASSWD: /sbin/ipset, /sbin/iptables-save, /sbin/iptables-restore , /sbin/ip6tables-save, /sbin/ip6tables-restore
    
- All:

        create 'dog' user:

        mkdir /var/log/dog
        chown dog: /var/log/dog
        mkdir /var/db/dog
        chown dog: /var/db/dog
        mkdir /tmp/dog
        chown dog: /tmp/dog
        mkdir /tmp/erl_pipes
        chown dog: /tmp/erl_pipes

## Build Dependencies
- erlang 22+

## Certificate Creation
Each agent must have it's own unique client certificate to connect to rabbitmq.

Check https://github.com/Phonebooth/dog_trainer/README.md#ca-certificate-creation for steps.

## Deploy Configuration
    apt install virtualenv
    virtualenv /opt/dog_env
    source /opt/dog_env/bin/activate
    pip install -r /opt/dog/requirements.txt
    cd /opt/dog
    ansible.sh

## Build Release Deploy
    $ rebar as $ENV tar

    copy tar to system, extract to /opt/dog_trainer

## Deploy
    #update version metadata:
    vim -o config/$ENV.sys.config src/dog.app.src rebar.config
    $ ./rebar3 as $ENV tar

    sudo mkdir /opt/dog.$VERSION
    cd /opt/dog.$VERSION
    sudo tar xf dog.$VERSION.tar.gz
    sudo chown -R dog: /opt/dog.$VERSION
    sudo rm /opt/dog
    sudo ln -s dog.$VERSION /opt/dog

## Agent Configuration
    #TODO

## Run

- Systemd(Ubuntu+)

      cp config/dog.service /lib/systemd/system/dog.service
      systemctl enable dog
      systemctl start dog

- SysV init (CentOS 6-)

      cp config/dog.init /etc/init.d/dog
      chkconfig dog on
      /etc/init.d/dog start

## Logs
    /var/log/dog/
