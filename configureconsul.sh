bash -c "cat >/etc/consul.d/consul.json" << EOF
{
  "server": true,
  "bootstrap_expect": 3,
  "raft_protocol": 3,
  "datacenter": "superduper",
  "raft_protocol": 3,
  "retry_join": ["192.168.13.35","192.168.13.36","192.168.13.37"],
  "advertise_addr": "$(hostname -I |grep -Eo '192\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')",
  "leave_on_terminate": true,
  "data_dir": "/opt/consul/data",
  "client_addr": "0.0.0.0",
  "log_level": "INFO",
  "ui": true,
  "acl_datacenter": "superduper",
  "acl_default_policy": "allow",
  "acl_down_policy": "allow",
  "acl_agent_master_token": "testtoken"
}
EOF

  ##  Tell the OS to run Consul Snapshot
  ##  once per hour.
line="*/60 * * * * /usr/local/bin/consul snapshot save \"/opt/consul/snapshots/consul_snapshot_$(date '+%Y%m%dT%H%M%S').snap\""
(crontab -u $USER -l; echo "$line" ) | crontab -u $USER -
