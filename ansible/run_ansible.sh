#!/bin/bash
echo "whoami: $(whoami)"
echo "groups: $(groups)"
echo "PATH: $PATH"
echo "SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
date +%s | sha256sum | base64 | head -c 32 > /ansible/ca_passphrase.txt

sudo sed -i '/.*\w*dog-server$/d' /etc/hosts
sudo sed -i '/.*\w*app-server$/d' /etc/hosts
sudo sed -i '/.*\w*db-server$/d' /etc/hosts
sudo lxc list -c 4n --format csv | sed 's/ (.*),/\t/g' | sudo tee -a /etc/hosts

lxc file push /home/vagrant/.ssh/authorized_keys dog-server/root/.ssh/authorized_keys --uid 0 --gid 0 --mode 0600
lxc file push /home/vagrant/.ssh/authorized_keys app-server/root/.ssh/authorized_keys --uid 0 --gid 0 --mode 0600
lxc file push /home/vagrant/.ssh/authorized_keys db-server/root/.ssh/authorized_keys --uid 0 --gid 0 --mode 0600

cd /ansible

# Install erlang build dependencies
sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libpng-dev libssh-dev xsltproc libxml2-utils libncurses-dev unzip
#cp -r /ansible/vagrant_dot_asdf /home/vagrant/.asdf
#sudo cp /ansible/vagrant_profile-d_asdf_sh /etc/profile.d/asdf.sh
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
echo ". $HOME/.asdf/asdf.sh" >> ~/.bash_profile
echo ". $HOME/.asdf/completions/asdf.bash" >> ~/.bash_profile
. ~/.bash_profile
asdf plugin add erlang
asdf plugin add elixir
asdf install erlang 22.3.2
asdf global erlang 22.3.2
asdf install elixir 1.9.4
asdf global elixir 1.9.4
asdf current

ls -latr /home/vagrant/.ansible/tmp
echo $PATH

lxc list
ansible-playbook -v -i hosts main.yml -u root

sudo apt-get install -y jq facter
cd /ansible/repos/dog_trainer/test
./box_setup.sh
sleep 20
./box_verify.sh
