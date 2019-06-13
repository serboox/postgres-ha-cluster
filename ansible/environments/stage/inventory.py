#!/usr/bin/env python
'''
Example custom dynamic inventory script for Ansible, in Python.
'''

import os
import sys
import argparse

try:
    import json
except ImportError:
    import simplejson as json


class ExampleInventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()

        # Called with `--list`.
        if self.args.list:
            self.inventory = self.example_inventory()
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        elif self.args.test:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        # If no groups or vars are present, return an empty inventory.
        else:
            self.inventory = self.empty_inventory()

        print(json.dumps(self.inventory))

        # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action='store_true')
        parser.add_argument('--host', action='store')
        parser.add_argument('--test', action='store_true')
        self.args = parser.parse_args()

    # Example inventory for testing.
    def example_inventory(self):
        return {
            "_meta": {
                "hostvars": {
                    "master1": {
                        "ansible_host": "192.168.0.9",
                    },
                    "slave1": {
                        "ansible_host": "192.168.0.6",
                    },
                    "slave2": {
                        "ansible_host": "192.168.0.13",
                    },
                    "srv1": {
                        "ansible_host": "185.91.52.35",
                    }
                }
            },
            "all": {
                "children": [
                    "ungrouped",
                    "srv",
                    "postgres-cluster"
                ],
                "hosts": [],
                "vars": {
                    "ansible_python_interpreter": "/usr/bin/python3",
                    "env": "stage",
                    "pg_user": "postgres",
                    "pg_version": 10
                }
            },
            "pg-master": {
                "children": [],
                "hosts": [
                    "master1"
                ],
                "vars": {
                    "role": "master"
                }
            },
            "pg-slave": {
                "children": [],
                "hosts": [
                    "slave1",
                    "slave2"
                ],
                "vars": {
                    "role": "slave"
                }
            },
            "postgres-cluster": {
                "children": [
                    "pg-master",
                    "pg-slave"
                ],
                "hosts": [],
                "vars": {
                    "ansible_ssh_common_args": "-o ProxyCommand=\"ssh -A -W %h:%p -q root@185.91.52.35\""
                }
            },
            "srv": {
                "children": [],
                "hosts": [
                    "srv1"
                ],
                "vars": {}
            },
            "ungrouped": {
                "children": [],
                "hosts": [],
                "vars": {}
            }
        }

    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # OpenStack inventory
    def openstack_inventory(self):
        res = {'_meta': {'hostvars': {}}}
        return res


# Get the inventory.
ExampleInventory()
