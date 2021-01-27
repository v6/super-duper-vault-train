#!/usr/bin/env/bash

ADDR="$(hostname -i)"
HOST="$(hostname -f)"

## Install Vault without Vagrant

./account.sh

./vaultpaths.sh

./configureraftvault.sh

./vaultsystemd.sh

./update_root_trust_store.sh

sudo systemctl start vault; sudo systemctl status vault
sudo journalctl -eu vault
