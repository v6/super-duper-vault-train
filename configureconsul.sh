bash -c "cat >/etc/consul.d/consul.json" << EOF
{
  "server": true,
  "bootstrap_expect": 3,
  "datacenter": "superduper",
  "retry_join": ["192.168.13.35","192.168.13.36","192.168.13.37"],
  "advertise_addr": "$(hostname -I |grep -Eo '192\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')",
  "leave_on_terminate": true,
  "data_dir": "/opt/consul/data",
  "client_addr": "0.0.0.0",
  "log_level": "INFO",
  "ui": true
}
EOF
