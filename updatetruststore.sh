#!/usr/bin/env bash

echo 'update-ca-trust'
sudo cp /etc/ssl/vault/*.cer /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust
