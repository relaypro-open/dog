#!/bin/bash
sudo ss -plnt
ssh dog-vm-host "
    hostname;\
    lxc list;\
    ps -ef | grep rabbit | grep -v grep; \
    ps -ef | grep dog_trainer | grep -v grep; \
    ps -ef | grep dog/ | grep -v grep; \
    ps -ef | grep rethinkdb | grep -v grep; \
    sudo ss -lnpt"
