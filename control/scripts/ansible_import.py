#!/bin/env python3
import os
import sys
import subprocess
import configparser
from yaml import load
try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader
import apiclient
import dog.api as dc

ansible_basedir = "/home/dgulino/Documents/workspace/playbyplay"
dog_url = "https://dog-qa.relaydev.sh:8443/api/V2"
dog_env = "qa"
ansible_envs = ["mob_qa", "beta_qa", "stage.qa"]
# ansible_basedir = "/ansible"
# dog_url = "http://kong:8000/api/V2"
# dog_env = "docker"
# ansible_envs = ["docker"]
hosts = {}
groups = {}


def create_client():
    creds_path = os.path.expanduser('~/.dog/credentials')
    if os.path.exists(creds_path):
        config = configparser.ConfigParser()
        config.read(creds_path)
        creds = config[dog_env]
        config_token = creds["token"]
    client = dc.DogClient(base_url=dog_url, apitoken=config_token)
    return client


def update_hosts(client):
    for host_name, host_vars in hosts.items():
        print(f"host_name: {host_name}, host_vars: {host_vars}")
        try:
            # host = client.get_host_by_hostkey(host_name) #docker
            host = client.get_host_by_name(host_name)
        except apiclient.exceptions.ClientError as ex:
            print(ex)
            continue
        if not host_vars:
            host_vars = {}
        host_id = host.get("id")
        print(f"host_id: {host_id}")
        host.update({"vars": host_vars})
        #print(f"host: {host}")
        client.update_host(host_id, host)
        #break


def update_groups(client):
    for group_name, group_vars in groups.items():
        if group_name == "ungrouped":
            continue
        print(f"group_name: {group_name}, group_vars: {group_vars}")
        try:
            group = client.get_group_by_name(group_name)
        except apiclient.exceptions.ClientError as ex:
            print(ex)
            continue

        if not group_vars:
            group_vars = {}
        # print(f"group: {group}")
        group_id = group.get("id")
        print(f"group_id: {group_id}")
        # print(f"group_vars: {group_vars}")
        group.update({"vars": group_vars})
        #print(f"group: {group}")
        client.update_group(group_id, group)
        #break


def main(argv, stdout, environ):
    for env in ansible_envs:
        inventory_export_cmd = f'cd {ansible_basedir}; ansible-inventory -i environments/{env}/hosts --list --export -y'
        completed_process = subprocess.run(inventory_export_cmd, shell=True, check=True, capture_output=True)
        if completed_process.returncode == 0:
            # print(f"completed_process: {completed_process.stdout}")
            all = load(completed_process.stdout, Loader=Loader)
            # print(f"all: {all}")
            group_children = all.get("all").get("children", {})
            # print(f"group_children: {group_children}")
            # print(f"groups: {groups}")
            # print(f"hosts: {hosts}")
            for group_name, group in group_children.items():
                # print(f"group: {group}")
                group_hosts = group.get("hosts", {})
                # group_vars = group.get("vars", {})
                groups[group_name] = group.get("vars")
                for host_name, child in group_hosts.items():
                    # print(f"child: {child}")
                    hosts[host_name] = child

    print(f'groups: {groups}')
    print(f'hosts: {hosts}')

    print("UPDATES")
    client = create_client()
    update_hosts(client)
    update_groups(client)


if __name__ == "__main__":
    main(sys.argv, sys.stdout, os.environ)
