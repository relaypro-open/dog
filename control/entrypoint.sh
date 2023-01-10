#!/bin/sh
/terraform_setup.sh
ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@"
