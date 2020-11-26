#!/bin/bash
#ubuntu 20.04:

## install qemu-kvm
#sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients virtinst cpu-checker libguestfs-tools libosinfo-bin

# install virtualbox
# NOTE: You cannot have any non-standard kernels installed (even if not running) to install virtualbox, 
# otherwise kernel dkms module installation will fail.
sudo apt-get install -y virtualbox

#install vagrant:
wget -nc https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb
sudo apt-get install -y ./vagrant_2.2.14_x86_64.deb

# qemu-kvm:
#vagrant plugin install vagrant-libvirt
#vagrant plugin install vagrant-mutate
#sudo chown root:kvm /dev/kvm

# virtualbox:
vagrant plugin install vagrant-vbguest

vagrant up

vagrant ssh-config | tee -a ~/.ssh/config

scp -r dog-vm-host_ansible dog-vm-host:ansible

echo "how to connect: 
vagrant ssh 
or
ssh dog-vm-host"
