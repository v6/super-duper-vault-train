sudo bash -c "cat >/etc/yum.repos.d/MariaDB.repo" << 'EOF'
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

sudo yum -d 0 install -y mariadb
