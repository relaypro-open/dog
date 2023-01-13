#!/bin/bash
ansible all -i dog.yml -m shell -a hostname
