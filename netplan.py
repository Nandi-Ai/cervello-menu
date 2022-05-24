    #!/usr/bin/env python
from ast import expr_context
import sys
from jinja2 import Template
if sys.argv[1] == "-dhcp" and sys.argv[2] == "false":
    with open("template.yml", "r") as file:
        fstr = file.read()
    try:
        tm = Template(fstr)
        with open("linkname.txt", "r") as file:
            linkname = file.read()
    except:
        linkname = ""
    dhcp4 = "dhcp: false"
    try:
        with open("ip.txt", "r") as file:
            ip = file.read()
    except:
        ip=""
    try:
        with open("dns.txt", "r") as file:
            dns = file.read()
    except:
        dns=""
    nameservers = "nameservers: \n        addresses: " + dns
    try:
        with open("gateway4.txt", "r") as file:
           gateway4 = file.read()
    except:
        gateway = ""
    try:
        with open("subnet.txt", "r") as file:
            subnet = file.read()
    except:
        subnet = ""
    try:
        with open("to.txt", "r") as file:
            to = file.read()
    except:
        to=""
    via = ""
    routes = "routes: \n      - to: " + to + subnet + "\n        via: " + gateway4
    msg = tm.render(subnet=subnet, linkname=linkname, dhcp4=dhcp4, ip=ip, gateway4=gateway4, dns=dns, routes=routes)
    text_file = open("config.yml", "w")
    n = text_file.write(msg)
    text_file.close()
    print(msg)