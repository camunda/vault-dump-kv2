#!/usr/bin/env python

from __future__ import print_function
import datetime
import os
import sys

import hvac

# Source: https://hvac.readthedocs.io/en/stable/usage/secrets_engines/kv_v2.html
client = hvac.Client()

def print_secret(path, mountpoint):
  content = client.secrets.kv.v2.read_secret_version(path, mount_point=mountpoint)['data']['data']

  print ("vault kv put {}{}".format(vault_dump_mountpoint, path), end='')
  for key in sorted(content.keys()):
    value = content[key]
    # try:
    #   value = value.encode("utf-8")
    # except AttributeError:
    #   value = value
    print (" {0}=\"{1}\"".format(key, value.replace('"', '\\"')), end='')
  print ()

def recurse_secrets(path_prefix, mountpoint):
  keys = client.secrets.kv.v2.list_secrets(path_prefix, mount_point=mountpoint)['data']['keys']
  for key in keys:
    item_path = path_prefix + key
    if key.endswith('/'):
      recurse_secrets(item_path, mountpoint)
    else:
      print_secret(item_path, mountpoint)


vault_dump_mountpoint = os.environ.get('VAULT_DUMP_MOUNTPOINT', '/secret/')

print ('#')
print ('# vault-dump-kv2.py backup')
print ("# backup date: {} UTC".format(datetime.datetime.utcnow()))
print ("# VAULT_DUMP_MOUNTPOINT setting: {}".format(vault_dump_mountpoint))
print ('# STDIN encoding: {}'.format(sys.stdin.encoding))
print ('# STDOUT encoding: {}'.format(sys.stdout.encoding))
print ('#')
print ('# WARNING: not guaranteed to be consistent!')
print ('#')

recurse_secrets('', vault_dump_mountpoint)