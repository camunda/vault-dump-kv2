# vault-dump-kv2

[![ci](https://github.com/camunda/vault-dump-kv2/actions/workflows/ci.yml/badge.svg)](https://github.com/camunda/vault-dump-kv2/actions/workflows/ci.yml)

Dump your [Hashicorp Vault](https://www.vaultproject.io/) KV version 2 secrets engine contents to a file.
Inspired by [vault-backup](https://github.com/shaneramey/vault-backup) but updated to work with KV version 2 only. Not guaranteed to be consistent.

## Environment Variables

In addition to the environment variables like `VAULT_ADDR` that the [hvac Python client for Hashicorp Vault](https://python-hvac.org/) implicitly uses, the following are used by this script:

- `PYTHONIOENCODING` is used to ensure your keys are exported in valid encoding, make sure to use the same during import/export
- `VAULT_DUMP_MOUNTPOINT` optionally passed as [`mount_point` argument](https://hvac.readthedocs.io/en/stable/usage/secrets_engines/kv_v2.html) to the hvac Python client
- `VAULT_DUMP_PATH_PREFIX` optionally can be used to only dump a sub path (e.g. `"my/nested/path/"`) of the KV version 2 secrets engine

## Setup

You need to have the `vault` CLI tool and [pipenv](https://pipenv.pypa.io/) installed.

```sh
vault login # with auth method of your choice

pipenv install # reads dependencies from Pipfile

export PYTHONIOENCODING="utf-8"
export VAULT_DUMP_MOUNTPOINT="/mysecrets/"
python vault-dump-kv2.py > mysecrets.txt
```

The generated script can be run with `sh mysecrets.txt` but beware that all keys in the target Vault will be overwritten on import!

## Development

To run all checks and tests locally do:

```sh
export PYTHONIOENCODING="utf-8"
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_DEV_ROOT_TOKEN_ID="test"

docker run -d --name vault -p 8200:8200 -e VAULT_DEV_ROOT_TOKEN_ID vault

make
```

Alternatively you can also open a [Pull Request](https://github.com/camunda/vault-dump-kv2/pulls) against this repository and let the CI run the checks and tests.
