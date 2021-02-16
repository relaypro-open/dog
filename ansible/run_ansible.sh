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

lxc file push /home/vagrant/.ssh/authorized_keys dog-server/root/.ssh/authorized_keys --uid 0 --gid 0 --mode 0600
lxc file push /home/vagrant/.ssh/authorized_keys dog-agent1/root/.ssh/authorized_keys --uid 0 --gid 0 --mode 0600
lxc file push /home/vagrant/.ssh/authorized_keys dog-agent2/root/.ssh/authorized_keys --uid 0 --gid 0 --mode 0600

cd /ansible

#cp -r /ansible/vagrant_dot_asdf /home/vagrant/.asdf
#sudo cp /ansible/vagrant_profile-d_asdf_sh /etc/profile.d/asdf.sh
. /etc/profile
. /etc/bash.bashrc
asdf global erlang 22.3.2
asdf global elixir 1.9.4
asdf current

ls -latr /home/vagrant/.ansible/tmp
echo $PATH

lxc list
ansible-playbook -v -i hosts main.yml -u root
logout
