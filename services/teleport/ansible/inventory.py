from sshconf import read_ssh_config
from os.path import expanduser
import argparse

c = read_ssh_config(expanduser("~/.ssh/config"))

parser = argparse.ArgumentParser(description='Convert ssh config to ansible hosts')
parser.add_argument('--list', action='store_true', help='list groups with hosts')
args = parser.parse_args()

# if args.list:
#    print(c.hosts())

groups = {}
for host in c.hosts():
    host_info = host.split('_')
    if len(host_info) != 3:
        continue
    project = host_info[0]
    env = host_info[1]
    name = host_info[2]
    print(host)