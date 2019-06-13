#!/usr/bin/env python
'''
Example custom dynamic inventory script for Ansible, in Python.
'''

import os
import sys
import argparse
from keystoneauth1 import identity
from keystoneauth1 import session
from novaclient import client

try:
    import json
except ImportError:
    import simplejson as json


class ExampleInventory(object):

    def __init__(self):
        self._nova_client_version = 2
        self._inventory = {}
        self.res = {'_meta': {'hostvars': {}}}

        self._set_environmet_variables()
        self._read_cli_args()

        # Called with `--list`.
        if self._args.list:
            self._inventory = self._example_inventory()
        # Called with `--host [hostname]`.
        elif self._args.host:
            # Not implemented, since we return _meta info `--list`.
            self._inventory = self._empty_inventory()
        elif self._args.test:
            # Not implemented, since we return _meta info `--list`.
            self._inventory = self._openstack_inventory()
        # If no groups or vars are present, return an empty inventory.
        else:
            self._inventory = self._empty_inventory()

        print(json.dumps(self._inventory))

    def _set_environmet_variables(self):
        self._os_auth_url = os.getenv('OS_AUTH_URL')
        self._os_x_token = os.getenv('OS_X_TOKEN')
        self._os_project_name = os.getenv('OS_PROJECT_NAME')
        self._os_user_domain_name = os.getenv('OS_USER_DOMAIN_NAME')
        self._os_username = os.getenv('OS_USERNAME')
        self._os_password = os.getenv('OS_PASSWORD')
        self._os_region = os.getenv('OS_REGION')
        self._os_availability_zone = os.getenv('OS_AVAILABILITY_ZONE')

    def _read_cli_args(self):
        '''
        Read the command line args passed to the script.
        '''
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action='store_true')
        parser.add_argument('--host', action='store')
        parser.add_argument('--test', action='store_true')
        self._args = parser.parse_args()

    def _example_inventory(self):
        '''
        Example inventory for testing.
        '''
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

    def _empty_inventory(self):
        '''
        Empty inventory for testing
        '''
        return {'_meta': {'hostvars': {}}}

    def _openstack_inventory(self):
        '''
        Generate custom Ansible inventory
        '''
        self._get_identity_session()
        self._init_nova_client()

        servers_list = self.nova.servers.list()
        for server in servers_list:
            # print(server.__dict__.keys())
            print('{id: %s, name: %s, addresses: %s}' % (
                server.id,
                server.name,
                server.addresses['network_1'][0]['addr'],
            ))
            self.res['_meta']['hostvars'].pop({server.name: {
                'ansible_host': server.addresses['network_1'][0]['addr'],
            }})
        return self.res

    def _get_identity_session(self):
        auth = identity.V3Password(auth_url=self._os_auth_url,
                                   username=self._os_username,
                                   user_domain_name=self._os_user_domain_name,
                                   password=self._os_password,
                                   project_name=self._os_project_name,
                                   project_domain_name=self._os_user_domain_name)
        self.session = session.Session(auth=auth)

    def _init_nova_client(self):
        self.nova = client.Client(
            self._nova_client_version, session=self.session)


ExampleInventory()
