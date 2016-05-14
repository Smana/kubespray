#!/bin/bash

# Copyright (c) 2016 Pani Networks
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Suppress output
exec > /dev/null

# Create hosts
{% for n in groups['kube-node'] %}
romana host add {{ hostvars[n].inventory_hostname }} {{ hostvars[n].ansible_default_ipv4['address'] }} {{ romana_cidr | ipsubnet(16, groups['kube-node'].index(n)) | ipaddr(1) }} 9604
{% endfor %}

# Create some initial tenants and segments
romana tenant create default
romana segment add default default
romana tenant create kube-system
romana segment add kube-system default
romana tenant create tenant-a
romana segment add tenant-a default
romana segment add tenant-a backend
romana segment add tenant-a frontend
