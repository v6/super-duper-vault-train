#!/usr/bin/env bash

PLUGIN_ARCHIVE_NAME=$1

unzip -o $PLUGIN_ARCHIVE_NAME /etc/vault.d/plugin/
chmod -R 0644 /etc/vault.d/plugin/*
