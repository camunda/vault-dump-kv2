# vault-dump-kv2

Dump your [Hashicorp Vault](https://www.vaultproject.io/) KV version 2 secrets engine contents to a file.
Inspired by [vault-backup](https://github.com/shaneramey/vault-backup) but updated to work with KV version 2 only. Not guaranteed to be consistent.

# Environment Variables

In addition to the environment variables like `VAULT_ADDR` that the [hvac Python client for Hashicorp Vault](https://python-hvac.org/) implicitly uses, the following are used by this script:

- `PYTHONIOENCODING` is used to ensure your keys are exported in valid encoding, make sure to use the same during import/export
- `VAULT_DUMP_MOUNTPOINT` optionally passed as [`mount_point` argument](https://hvac.readthedocs.io/en/stable/usage/secrets_engines/kv_v2.html) to the hvac Python client

# Setup

You need to have the `vault` CLI tool and `pip` installed.

```sh
vault login # with auth method of your choice

pip3 install -r requirements.txt

export PYTHONIOENCODING="utf-8"
export VAULT_DUMP_MOUNTPOINT="/mysecrets/"
python vault-dump-kv2.py > mysecrets.txt
```

The generated script can be run with `sh mysecrets.txt` but beware that all keys in the target Vault will be overwritten on import!
