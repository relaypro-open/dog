# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-'SCRIPT'
#!/bin/bash
whoami
#add vagrant key to ssh-agent
ssh-add .vagrant/machines/dog-vm-host/virtualbox/private_key

echo $PATH

apt-get update -y
snap install lxd --channel=4.0/stable
lxd init --auto --storage-backend=btrfs --storage-create-loop=60 -v --network-address=127.0.0.1 --network-port=8443
adduser vagrant lxd

#lxc image import /ansible/lxd/ubuntu-20.04-server-cloudimg-amd64-lxd.tar.xz /ansible/lxd/ubuntu-20.04-server-cloudimg-amd64.squashfs --alias ubuntu-20.04

lxc launch ubuntu:20.04 dog-agent1 #duplicated on purpose, workaround for libvirt/kvm/vagrant/image? bug
lxc launch ubuntu:20.04 dog-agent1 #duplicated on purpose, workaround for libvirt/kvm/vagrant/image? bug
lxc config set dog-agent1 raw.idmap 'both 1000 1000'
lxc config device add dog-agent1 sitedir disk source=/home/vagrant path=/opt/home
lxc launch ubuntu:20.04 dog-agent2
lxc config set dog-agent2 raw.idmap 'both 1000 1000'
lxc config device add dog-agent2 sitedir disk source=/home/vagrant path=/opt/home
lxc launch ubuntu:20.04 dog-server
lxc config set dog-server raw.idmap 'both 1000 1000'
lxc config device add dog-server sitedir disk source=/home/vagrant path=/opt/home
lxc config device add dog-server dog-gui proxy listen=tcp:0.0.0.0:3000 connect=tcp:127.0.0.1:3000
lxc config device add dog-server rethinkdb-gui proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:8080
lxc config device add dog-server rabbitmq-gui proxy listen=tcp:0.0.0.0:15672 connect=tcp:127.0.0.1:15672

#add lxc container ips to /etc/hosts of vm

#apt-get install -y python=3.8.2-0ubuntu2
#apt-get install -y python3-pip=20.0.2-5ubuntu1.1
apt-get install -y ansible=2.9.6+dfsg-1
#ansible-galaxy collection install community.general
#/ansible directory shared via vangrant sync folder
#
#setup to allow normal ssh access for ansible:

#cd /ansible
#pwd
#ls -latr
#whoami
#echo "SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
#sudo --preserve-env=SSH_AUTH_SOCK -u vagrant /ansible/run_ansible.sh
lxc restart dog-server
lxc restart dog-agent1
lxc restart dog-agent2
SCRIPT

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
#  if Vagrant.has_plugin?("vagrant-proxyconf")
#    config.proxy.http     = "http://192.168.145.1:3128/"
#    config.proxy.https    = "http://192.168.145.1:3128/"
#    config.proxy.no_proxy = "localhost,127.0.0.1"
#  end
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  config.vm.define 'dog-vm-host' do |hostvm|
    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    # VM OS must match containers' OS because VM is used to build erlang application releases.
    config.vm.box = "ubuntu/focal64" #20.04

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    config.vm.network 'forwarded_port', guest: 3000, host: 3000, host_ip: '127.0.0.1'
    config.vm.network 'forwarded_port', guest: 8080, host: 8080, host_ip: '127.0.0.1'
    config.vm.network 'forwarded_port', guest: 15672, host: 15672, host_ip: '127.0.0.1'

    # config.vm.provider :libvirt do |libvirt|
    config.vm.provider :virtualbox do |v|
      config.vm.hostname = 'dog-vm-host'
      config.vm.synced_folder 'ansible/', '/ansible'
      config.ssh.forward_agent = true
      #config.ssh.private_key_path = [ '~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa' ]
      v.name = 'dog-vm-host'
      v.check_guest_additions = true
      v.gui = false
      v.memory = 3072
      v.cpus = 2
    end

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    #
    # sudo snap install lxd --channel=4.0/stableargument is a set of non-required options.
    # config.vm.synced_folder '../data', '/vagrant_data'

    config.vm.provision 'shell', 
      inline: $script#,
      #privileged: false
  end
end
