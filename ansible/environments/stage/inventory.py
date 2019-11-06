#!/usr/bin/env python
# coding=utf8
'''
Example custom dynamic inventory script for Ansible, in Python.
'''

import os
import sys
import argparse
import requests
import re
from urllib.parse import urlparse
from keystoneauth1.identity import v3
from keystoneauth1 import session
from keystoneclient.v3 import client as keystone_client
from novaclient import client as nova_client
from neutronclient.v2_0 import client as neutron_client

try:
    import json
except ImportError:
    import simplejson as json


class ExampleInventory(object):

    def __init__(self):
        self._nova_client_version = 2
        self._inventory = {}
        self.res = {
            '_meta': {
                'hostvars': {}
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
                    "pg_group": "postgres",
                    "replica_user_name": "replicator",
                    "pg_version": 10,
                    "local_network": "192.168.0.0/24",

                    "pgbouncer_listen_addr": "*",
                    "pgbouncer_listen_port": 6432,
                    "pgbouncer_max_client_conn": 10000,
                    "pgbouncer_default_pool_size": 30,
                    # Отвечает за количество одновременно подключенных слейвов у мастера.
                    "pg_max_wal_senders": 99,

                    "consul_version": "1.5.1",
                    "consul_user": "consul",
                    "consul_group": "consul",
                    "consul_http_port": 8500,
                    "consul_dns_port": 8600,
                    "consul_server_nodes": [],  # dynamic

                    "patroni_version": "v1.5.6",
                    "patroni_host": "0.0.0.0",
                    "patroni_port": 8008,
                    "patroni_username": "patroni",
                    "patroni_scope": "pg_cluster",

                    "haproxy_addr": "*",
                    "haproxy_port": 5000,
                    "haproxy_maxconn": 1000,
                    "cluster_virtual_ip": "192.168.1.0"
                }
            },
            "srv": {
                "children": [],
                "hosts": [],
                "vars": {
                    "role": "service",
                    "consul_agent": False,
                    "consul_server": False,
                    "consul_ui": True
                }
            },
            "pg-master": {
                "children": [],
                "hosts": [],
                "vars": {
                    "role": "master",
                }
            },
            "pg-slave": {
                "children": [],
                "hosts": [],
                "vars": {
                    "role": "slave",
                    "master_local_ip": '',  # dynamic
                    "master_host_name": ''  # dynamic
                }
            },
            "postgres-cluster": {
                "children": [
                    "pg-master",
                    "pg-slave"
                ],
                "hosts": [],
                "vars": {
                    "ansible_ssh_common_args": "-o ProxyCommand=\"ssh -A -W %h:%p -q root@185.91.52.35\"",

                    "pg_listen_addresses": "*",
                    "pg_port": 5432,
                    "pg_max_connections": 100,
                    "pg_shared_buffers": "128MB",
                    "pg_unix_socket_directories": '/var/run/postgresql',

                    "consul_agent": False,
                    "consul_server": True,
                    "consul_ui": False
                }
            },
            "ungrouped": {
                "children": [],
                "hosts": [],
                "vars": {}
            }
        }

        self._set_environmet_variables()
        self._read_cli_args()

        # Called with `--list`.
        if self._args.list:
            self._inventory = self._build_selectel_inventory()
        # Called with `--host [hostname]`.
        elif self._args.host:
            # Not implemented, since we return _meta info `--list`.
            self._inventory = self._empty_inventory()
        # If no groups or vars are present, return an empty inventory.
        else:
            self._inventory = self._build_selectel_inventory()

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
        self._resell_url = os.getenv('RESELL_API_URL')

    def _read_cli_args(self):
        '''
        Read the command line args passed to the script.
        '''
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action='store_true')
        parser.add_argument('--host', action='store')
        self._args = parser.parse_args()

    def _example_inventory(self):
        '''
        Example inventory for testing.
        '''
        with open('inventory.json', mode='r') as json_file:
            return json.load(json_file)

    def _empty_inventory(self):
        '''
        Empty inventory for testing
        '''
        return {'_meta': {'hostvars': {}}}

    def _build_selectel_inventory(self):
        '''
        Generate custom Ansible inventory
        '''
        projects_list = self._find_projects_list()
        # print('projects list: %s' % projects_list)
        for project in projects_list['projects']:
            if project['name'] == self._os_project_name:
                self._current_project = project

        floatingip_list = self._find_floatingip_list()
        for floatingip in floatingip_list['floatingips']:
            if floatingip['project_id'] == self._current_project['id']:
                self._current_floatingip = floatingip
                break
        # print('floatingip list: %s' % floatingip_list)
        # print('current_floatingip: %s' % self._current_floatingip)

        self._get_identity_session()
        # print('token: %s' % self.session.get_token())
        self._init_nova_client()
        self._init_neutron_client()

        networks_list = self.neutron.list_networks(name="network_1")
        # print('networks_list: %s' % networks_list)

        servers_list = self.nova.servers.list()
        # print('servers_list: %s' % servers_list)
        for server in servers_list:
            # print(server.__dict__.keys())
            # print('{id: %s, name: %s, addresses: %s}' % (
            #    server.id,
            #    server.name,
            #    server.addresses['network_1'][0]['addr'],
            # ))
            self.res['_meta']['hostvars'][server.name] = {
                'ansible_host': server.addresses['network_1'][0]['addr'],
            }

            res = re.findall(r'srv', server.name)
            if len(res) != 0:
                self.res['_meta']['hostvars'][server.name] = {
                    'ansible_host': self._current_floatingip['floating_ip_address'],
                }
                self.res['srv']['hosts'].append(server.name)
                self.res['postgres-cluster']['vars']['ansible_ssh_common_args'] = \
                    "-o ProxyCommand=\"ssh -A -W %h:%p -q root@{}\"".\
                    format(self._current_floatingip['floating_ip_address'])

            res = re.findall(r'master', server.name)
            if len(res) != 0:
                self.res['pg-master']['hosts'].append(server.name)
                self.res['pg-slave']['vars']['master_host_name'] = server.name
                self.res['pg-slave']['vars']['master_local_ip'] = \
                    server.addresses['network_1'][0]['addr']
                self.res['all']['vars']['consul_server_nodes'].append(
                    server.addresses['network_1'][0]['addr']
                )

            res = re.findall(r'slave', server.name)
            if len(res) != 0:
                self.res['pg-slave']['hosts'].append(server.name)
                self.res['all']['vars']['consul_server_nodes'].append(
                    server.addresses['network_1'][0]['addr']
                )
        return self.res

    def _get_identity_session(self):
        auth = v3.Password(auth_url=self._os_auth_url,
                           username=self._os_username,
                           user_domain_name=self._os_user_domain_name,
                           password=self._os_password,
                           project_name=self._os_project_name,
                           project_domain_name=self._os_user_domain_name)
        self.session = session.Session(auth=auth)

    def _find_projects_list(self):
        req_url = '%s/projects' % (self._resell_url)
        # print(req_url)
        headers = {'X-token': self._os_x_token}
        r = requests.get(req_url, headers=headers)
        return json.loads(r.text)

    def _find_floatingip_list(self):
        req_url = '%s/floatingips' % (self._resell_url)
        # print(req_url)
        headers = {'X-token': self._os_x_token}
        r = requests.get(req_url, headers=headers)
        return json.loads(r.text)

    def _init_nova_client(self):
        self.nova = nova_client.Client(
            session=self.session,
            version=self._nova_client_version,
            region_name=self._os_region,
        )

    def _init_neutron_client(self):
        self.neutron = neutron_client.Client(
            session=self.session,
            region_name=self._os_region,
        )


ExampleInventory()
