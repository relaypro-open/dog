#!/bin/bash -x
vagrant global-status | grep dog-vm-host
vagrant port dog-vm-host
sudo ss -plnt
ssh dog-vm-host "hostname;"
ssh dog-vm-host "lsb_release -a;"
ssh dog-vm-host "lxc list;"
ssh dog-vm-host "ps -ef | grep rabbit | grep -v grep;"
ssh dog-vm-host "ps -ef | grep /opt/dog_trainer\\\. | grep -v grep;"
ssh dog-vm-host "ps -ef | grep /opt/dog\\\. | grep -v grep;"
ssh dog-vm-host "ps -ef | grep rethinkdb | grep -v grep;"
ssh dog-vm-host "sudo ss -lnpt"
