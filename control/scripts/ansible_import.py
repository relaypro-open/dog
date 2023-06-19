#!/bin/env python3
import os
import sys
import subprocess
import configparser
from yaml import load
from urllib.parse import quote_plus
try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader
import apiclient
import dog.api as dc
import difflib

ansible_basedir = "/home/dgulino/Documents/workspace/playbyplay"
dog_url = "https://dog-qa.relaydev.sh:8443/api/V2"
dog_env = "qa"
ansible_envs = ["mob_qa", "beta_qa", "stage.qa"]
# ansible_basedir = "/ansible"
# dog_url = "http://kong:8000/api/V2"
# dog_env = "docker"
# ansible_envs = ["docker"]

def create_client():
    creds_path = os.path.expanduser('~/.dog/credentials')
    if os.path.exists(creds_path):
        config = configparser.ConfigParser()
        config.read(creds_path)
        creds = config[dog_env]
        config_token = creds["token"]
    client = dc.DogClient(base_url=dog_url, apitoken=config_token)
    return client


def update_hosts(client, hosts):
    for host_name, host_vars in hosts.items():
        # if host_name != 'it-build-qa-aws01.phoneboothdev.info':
        #     continue
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
        new_hostkey = quote_plus(host.get("hostkey"))
        host["hostkey"] = new_hostkey
        # print(f"host: {host}")
        client.update_host(host_id, host)


def generate_rough_group_mapping(client, groups):
    ansible_group_to_dog_group_mapping = {}
    dog_groups = client.get_all_groups()
    dog_group_names = [group.get('name') for group in dog_groups]
    for group_name, group_vars in groups.items():
        matches = difflib.get_close_matches(group_name, dog_group_names, n=1)
        ansible_group_to_dog_group_mapping[group_name] = next(iter(matches), None)
        print(f"{group_name} {matches}")
    return ansible_group_to_dog_group_mapping


def update_groups(client, groups):
    for ansible_group_name, group_vars in groups.items():
        group_mapping = generate_rough_group_mapping(client, groups)
        dog_group_name = None
        if ansible_group_name == "ungrouped":
            continue
        if group_vars:
            dog_group_name = group_vars.get("dog_group", None)
        if not dog_group_name:
            dog_group_name = group_mapping.get(ansible_group_name)
        if not dog_group_name:
            continue
        # group_name = group_name + "_qa" # munge ansible group names to match dog group names
        print(f"ansible_group_name: {ansible_group_name}, dog_group_name: {dog_group_name}, group_vars: {group_vars}")
        try:
            group = client.get_group_by_name(dog_group_name)
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
        # break


def gather_ansible_invetory(env):
    hosts = {}
    groups = {}
    inventory_export_cmd = f'cd {ansible_basedir}; ansible-inventory -i environments/{env}/hosts --list --export -y'
    completed_process = subprocess.run(inventory_export_cmd, shell=True, check=True, capture_output=True)
    if completed_process.returncode == 0:
        # print(f"completed_process: {completed_process.stdout}")
        all = load(completed_process.stdout, Loader=Loader) # print(f"all: {all}")
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
    return hosts, groups


def main(argv, stdout, environ):
    client = create_client()
    for env in ansible_envs:
        hosts, groups = gather_ansible_invetory(env)
        # update_hosts(client)
        print(f'groups: {groups}')
        print(f'hosts: {hosts}')
        print("UPDATES")
        update_hosts(client, hosts)
        update_groups(client, groups)


if __name__ == "__main__":
    main(sys.argv, sys.stdout, os.environ)
