#!/bin/bash
ansible docker -i environments/docker/hosts -m shell -a hostname
