#!/bin/bash
#ubuntu 20.04:
sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients virtinst cpu-checker libguestfs-tools libosinfo-bin

#install vagrant:
wget -nc https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb
sudo apt-get install -y ./vagrant_2.2.14_x86_64.deb

vagrant plugin install vagrant-libvirt
#vagrant plugin install vagrant-mutate

#vagrant init generic/ubuntu2020
sudo chown root:kvm /dev/kvm
#vagrant up --provider=libvirt #large download
vagrant up

vagrant ssh-config

#ssh vagrant@192.168.121.113 -i ~/Documents/workspace/dog/.vagrant/machines/default/libvirt/private_key
