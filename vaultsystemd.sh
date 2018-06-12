#!/usr/bin/env bash

sudo bash -c "cat >/etc/systemd/system/vault.service" << 'EOF'
[Unit]
Description=SystemD Vault Service
Requires=consul-online.target
After=consul-online.target

[Service]
Restart=on-failure
PermissionsStartOnly=true
ExecStartPre=/sbin/setcap 'cap_ipc_lock=+ep' /usr/local/bin/vault
ExecStart=/usr/local/bin/vault server -config /etc/vault.d
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
User=vault
Group=vault

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 0664 /etc/systemd/system/vault*
