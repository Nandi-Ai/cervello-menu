#!/usr/bin/env python
from ast import expr_context
import sys
import yaml
from jinja2 import Template
import argparse

parser = argparse.ArgumentParser(description="This script configures networking.")

parser.add_argument('-v', '--validate', required=False, default=False,
                    help="Validate connectivity with the interafeces")
parser.add_argument('-d', '--dhcp',  required=False, default=False, action='store_true',
                    help="Configuration DHCP for networking and machine setup")
parser.add_argument('-g', '--gateway', required=False, default="10.10.10.10",
                    help="This is to execute 'create machine' function to Conductor.")

parser.add_argument('-nr', '--noreboot', required=False, default=False, help="This is will disable reboot.")
args = parser.parse_args()

dhcp = args.dhcp
gateway4 = args.gateway

with open("template.yml", "r") as file:
    netPlanTemplate = file.read()
    netplan = Template(netPlanTemplate)

with open("interfaces.yaml", "r") as f:
    data = yaml.load(f, Loader=yaml.SafeLoader)


msg = netplan.render(data)


text_file = open("config.yml", "w")
n = text_file.write(msg)
text_file.close()
print(msg)

    
