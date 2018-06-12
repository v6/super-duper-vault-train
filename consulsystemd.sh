#!/usr/bin/env bash

  ##  Set up Consul Service
bash -c "cat >/etc/systemd/system/consul.service" << 'EOF'
[Unit]
Description=Consul Agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/consul agent -config-dir /etc/consul.d
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
User=consul
Group=consul

[Install]
WantedBy=multi-user.target
EOF

  ##  Set up Consul Online service
bash -c "cat >/etc/systemd/system/consul-online.service" << 'EOF'
[Unit]
Description=Consul Online
Requires=consul.service
After=consul.service

[Service]
Type=oneshot
ExecStart=/usr/bin/consul-online.sh
User=consul
Group=consul

[Install]
WantedBy=consul-online.target multi-user.target
EOF


  ##  Set up Consul Online script
bash -c "cat >/usr/bin/consul-online.sh" << 'EOF'
#!/usr/bin/env bash

set -e
set -o pipefail

localconsul=127.0.0.1:8500
# waitForConsulToBeAvailable loops until the local Consul agent returns a 200
# response at the /v1/operator/raft/configuration endpoint.
#
# Parameters:
#     None
function waitForConsulToBeAvailable() {
	local consul_addr=127.0.0.1:8500
		local consul_leader_http_code

		consul_leader_http_code=$(curl --silent --output /dev/null --write-out "%{http_code}" "${consul_addr}/v1/operator/raft/configuration") || consul_leader_http_code=""

		while [ "x${consul_leader_http_code}" != "x200" ] ; do
			echo "Waiting for Consul to get a leader..."
				sleep 5
				consul_leader_http_code=$(curl --silent --output /dev/null --write-out "%{http_code}" "${consul_addr}/v1/operator/raft/configuration") || consul_leader_http_code=""
				done
}

waitForConsulToBeAvailable "${localconsul}"
EOF


##  Set up Consul Online Target
bash -c "cat >/etc/systemd/system/consul-online.target" << 'EOF'
[Unit]
Description=Consul Online
RefuseManualStart=true
EOF



chmod 664 /etc/systemd/system/consul*
chmod 755 /usr/bin/consul-online.sh
