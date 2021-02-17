#!/bin/bash
vagrant plugin install vagrant-proxyconf

# virtualbox
vagrant plugin install vagrant-vbguest

vagrant up --provider=virtualbox

vagrant ssh-config | tee -a ~/.ssh/config

ssh-add .vagrant/machines/dog-vm-host/virtualbox/private_key

echo "provisioning script completed."

echo "how to connect: 
vagrant ssh 
or
ssh dog-vm-host"

ssh vagrant@dog-vm-host "/ansible/run_ansible.sh"
