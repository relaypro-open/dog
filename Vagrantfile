# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-'SCRIPT'
apt-get update -y
snap install lxd --channel=4.0/stable
lxd init --auto --storage-backend=btrfs --storage-create-loop=60 --syslog -v --network-address=127.0.0.1 --network-port=8443
lxc launch ubuntu:16.04 dog-agent1 #duplicated on purpose
lxc launch ubuntu:16.04 dog-agent1 #duplicated on purpose
lxc config set dog-agent1 raw.idmap 'both 1000 1000'
lxc config device add dog-agent1 sitedir disk source=/home/vagrant path=/opt/home
lxc launch ubuntu:16.04 dog-agent2
lxc config set dog-agent2 raw.idmap 'both 1000 1000'
lxc config device add dog-agent2 sitedir disk source=/home/vagrant path=/opt/home
lxc launch ubuntu:16.04 dog-server
lxc config set dog-server raw.idmap 'both 1000 1000'
lxc config device add dog-server sitedir disk source=/home/vagrant path=/opt/home
lxc config device add dog-server dog-gui proxy listen=tcp:0.0.0.0:3000 connect=tcp:127.0.0.1:3000
lxc config device add dog-server rethinkdb-gui proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:8080
lxc config device add dog-server rabbitmq-gui proxy listen=tcp:0.0.0.0:15672 connect=tcp:127.0.0.1:15672
lxc restart dog-server
lxc restart dog-agent1
lxc restart dog-agent2
#apt-get install -y python3-pip
#apt-get install -y ansible=2.9.6+dfsg-1
SCRIPT

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  config.vm.define 'host-vm' do |hostvm|

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    config.vm.box = 'generic/ubuntu2004'

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    config.vm.network 'forwarded_port', guest: 3000, host: 3000, host_ip: '127.0.0.1'
    config.vm.network 'forwarded_port', guest: 8080, host: 8080, host_ip: '127.0.0.1'
    config.vm.network 'forwarded_port', guest: 15672, host: 15672, host_ip: '127.0.0.1'

    config.vm.provider :libvirt do |libvirt|
      config.vm.hostname = 'dog-vm-host'
      libvirt.host = 'dog-vm-host'
    end

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    #
    # sudo snap install lxd --channel=4.0/stableargument is a set of non-required options.
    # config.vm.synced_folder '../data', '/vagrant_data'

    config.vm.provision 'shell', inline: $script
  end
end
