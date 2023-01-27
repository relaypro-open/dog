#!/bin/bash
ansible all -i environments/docker/ -m shell -a hostname
