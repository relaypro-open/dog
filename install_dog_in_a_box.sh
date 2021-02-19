#!/bin/bash
osType=$(uname)
case "$osType" in
        "Darwin")
        {
            echo "Running on Mac OSX."
            CURRENT_OS="OSX"
            echo "You must have VirtualBox and Vagrant installed before running this script."
        } ;;    
        "Linux")
        {
            # If available, use LSB to identify distribution
            if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
                DISTRO=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
            else
                DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
            fi
            CURRENT_OS=$(echo $DISTRO | tr 'a-z' 'A-Z')
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
        } ;;
        *) 
        {
            echo "Unsupported OS, exiting"
            exit
        } ;;
esac

vagrant plugin install vagrant-proxyconf

# virtualbox
vagrant plugin install vagrant-vbguest

vagrant up

vagrant ssh-config | tee -a ~/.ssh/config

ssh-add .vagrant/machines/dog-vm-host/virtualbox/private_key

echo "provisioning script completed."

echo "how to connect: 
vagrant ssh 
or
ssh dog-vm-host"

ssh vagrant@dog-vm-host "/ansible/run_ansible.sh"

echo "You should be able to access these resources on the physical host:"
echo "dog: http://localhost:3000"
echo "rabbitmq: http://localhost:15672"
echo "rethinkdb: http://localhost:8080"
