<p align="center">
  <img src="../images/dog-segmented-green.network-200x200.png">
</p>

<h1>dog_in_a_box</h1>

dog_in_a_box is a complete dog test/dev environment implemented on containers in a local virtual machine.
It's meant to provide a way to test changes to dog in a full environment built from scratch,
  and a way to easily try out dog.

# Details:
Vagrant is used to create a VirtualBox VM (dog-vm-host).  
dog-vm-host is a Ubuntu server, and acts as the build server for the applications
and hosts three LXD containers, all running Ubuntu also.
- dog-server: hosts dog_trainer, dog_park, rethinkdb, and rabbitmq
- dog-agent1,2: each run dog_agent

# Install:
- ensure your ssh-agent has the key(s) needed to access dog repos

### Linux (ubuntu 20.04, 20.10 host tested):

    git clone git@github.com:Phonebooth/dog.git

    cd dog

    ./install_dog_in_a_box-linux.sh

### MacOS:
- install Vagrant: (http://vagrantup.com)
- install VirtualBox: (http://virtualbox.org) - reboot required

    git clone git@github.com:Phonebooth/dog.git

    cd dog

    ./install_dog_in_a_box-mac.sh


# Use:
The dog VM is configured to forward the containers' service to the physical hosts' localhost ports

- dog [http://localhost:3000](http://localhost:3000)

- rethinkdb [http://localhost:8080](http://localhost:8080)

- rabbitmq [http://localhost:15672](http://localhost:15672)
