yum install -q -y dnsmasq
echo "server=/consul/127.0.0.1#8600"  >>  /etc/dnsmasq.d/consul
systemctl enable dnsmasq
systemctl restart dnsmasq
