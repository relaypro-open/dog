#!/bin/bash
echo "whoami: $(whoami)"
echo "groups: $(groups)"
echo "PATH: $PATH"
echo "SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
date +%s | sha256sum | base64 | head -c 32 > /ansible/ca_passphrase.txt

sudo sed -i '/.*\w*dog-server$/d' /etc/hosts
sudo sed -i '/.*\w*dog-agent1$/d' /etc/hosts
sudo sed -i '/.*\w*dog-agent2$/d' /etc/hosts
sudo lxc list -c 4n --format csv | sed 's/ (.*),/\t/g' | sudo tee -a /etc/hosts

#sudo groupadd dog -g 3000
#sudo useradd -m dog -u 3000 -g 3000 -s /bin/bash
#sudo mkdir /home/dog/.ssh; chown dog: /home/dog/.ssh; chmod 0700 /home/dog/.ssh
#cat /home/vagrant/.ssh/authorized_keys >> /home/dog/.ssh/authorized_keys
#chown dog: /home/dog/.ssh/authorized_keys
#chmod 0600 /home/dog/.ssh/authorized_keys
#echo "dog ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dog

#lxc exec dog-server -- bash -c "groupadd dog -g 3000"
#lxc exec dog-server -- bash -c "useradd -m dog -u 3000 -g 3000 -s /bin/bash"
#lxc exec dog-server -- bash -c "mkdir /home/dog/.ssh; chown dog: /home/dog/.ssh; chmod 0700 /home/dog/.ssh"
#lxc file push ~/.ssh/id_rsa.pub dog-server/home/vagrant/.ssh/id_rsa.pub --uid 1000 --gid 1000 --mode 0600
#lxc exec dog-server --bash -c 'echo /home/vagrant/.ssh/id_rsa.pub >> /r/.ssh/authorized_keys'
#lxc file push /home/vagrant/.ssh/authorized_keys dog-server/home/dog/.ssh/authorized_keys --uid 3000 --gid 3000 --mode 0600
lxc file push /home/vagrant/.ssh/authorized_keys dog-server/root/.ssh/authorized_keys --uid 0 --gid 0 --mode 0600
lxc file push /home/vagrant/.ssh/authorized_keys dog-agent1/root/.ssh/authorized_keys --uid 0 --gid 0 --mode 0600
lxc file push /home/vagrant/.ssh/authorized_keys dog-agent2/root/.ssh/authorized_keys --uid 0 --gid 0 --mode 0600
#lxc exec dog-server -- bash -c 'echo "dog ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dog'

#lxc exec dog-agent1 -- bash -c "groupadd dog -g 3000"
#lxc exec dog-agent1 -- bash -c "useradd -m dog -u 3000 -g 3000"
#lxc exec dog-agent1 -- bash -c "mkdir /home/dog/.ssh; chown dog: /home/dog/.ssh; chmod 0700 /home/dog/.ssh"
#lxc file push /home/vagrant/.ssh/authorized_keys dog-agent1/home/dog/.ssh/authorized_keys --uid 3000 --gid 3000 --mode 0600
#lxc exec dog-agent1 -- bash -c 'echo "dog ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dog'
#
#lxc exec dog-agent2 -- bash -c "groupadd dog -g 3000"
#lxc exec dog-agent2 -- bash -c "useradd -m dog -u 3000 -g 3000"
#lxc exec dog-agent2 -- bash -c "mkdir /home/dog/.ssh; chown dog: /home/dog/.ssh; chmod 0700 /home/dog/.ssh"
#lxc file push /home/vagrant/.ssh/authorized_keys dog-agent2/home/dog/.ssh/authorized_keys --uid 3000 --gid 3000 --mode 0600
#lxc exec dog-agent2 -- bash -c 'echo "dog ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dog'

cd /ansible

#ansible-playbook -i hosts asdf.yml
cp -r /ansible/vagrant_dot_asdf /home/vagrant/.asdf
sudo cp /ansible/vagrant_profile-d_asdf_sh /etc/profile.d/asdf.sh
. /etc/profile
. /etc/bash.bashrc
asdf global erlang 22.3.2
asdf global elixir 1.9.4
asdf current

ls -latr /home/vagrant/.ansible/tmp
echo $PATH

#newgrp lxd
lxc list
ansible-playbook -v -i hosts main.yml -u root
logout
