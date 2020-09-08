
# https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SILENT:
.SHELLFLAGS := -eux -o pipefail -c
.DELETE_ON_ERROR:
.DEFAULT_GOAL := all
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: all
all: lint e2e ## Run lint and test (default goal)

.PHONY: lint
lint: ## Lint all source code
	pipenv run yapf -q *.py
	pipenv run pylint *.py
	pipenv run mypy *.py

.PHONY: e2e
e2e: e2e-backup-default ## Run E2E tests against running Vault instance in dev mode

.PHONY: e2e-backup-default
e2e-backup-default: ## Run E2E test for using script with default parameters
	function cleanup {
		vault secrets disable secret
		vault secrets enable -path=secret kv-v2
	}
	trap cleanup EXIT

	# prepare environment
	export VAULT_ADDR='http://127.0.0.1:8200'
	vault status
	vault login $$VAULT_DEV_ROOT_TOKEN_ID

	# create backup, first drop all contents and then insert seed data
	cleanup
	vault kv put secret/test1 hello=world
	vault kv put secret/nested/test2 hello=world
	pipenv run python3 vault-dump-kv2.py > backup-default.sh

	# restore backup, again drop all contents first and then check restored data
	cleanup
	sh backup-default.sh
	[ $$(vault kv get -field hello secret/test1) == "world" ]
	[ $$(vault kv get -field hello secret/nested/test2) == "world" ]

.PHONY: help
help: ## Print this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
