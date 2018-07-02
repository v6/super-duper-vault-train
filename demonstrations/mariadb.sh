#!/usr/bin/env bash
echo '  ##  Assume RHEL, install mariadb'

echo "MariaDB Installation Begins"

[[ -z $1 ]] && { echo "  ##  Error: Set the MariaDB password in the Vagrant file."; exit 1; }

# set password
MARIADB_PASSWORD=$1

# default version
MARIADB_VERSION='10.1'

  ##  Add key for the repository occurs automatically
  ##  Add repo for MariaDB occurs automatically

sudo yum check-update


  ##  Auto-set password to avoid prompt while installing MariaDB
  ##  Set username to 'root' and password to 'errydayimSNUFFLIN'

  ##  Set password for mariadb user
echo "${MARIADB_PASSWORD}" | sudo passwd --stdin mariadb


  ##  Allow external connections to MariaDB
if [ $2 == "true" ]; then
    mkdir -p /etc/mysql
    touch /etc/mysql/my.cnf
      ##  Set bind addr to allow connections 0.0.0.0
    sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
fi

  ##  Install MariaDB
    sudo yum install -y -q -e 0 mariadb-server

      ##  Enable system service

    sudo systemctl enable mariadb.service
    sudo systemctl start mariadb

  ##  Add Root User Privileges
  ##  http://stackoverflow.com/questions/7528967/how-to-grant-mysql-privileges-in-a-bash-script
if [ $3 == "true" ]; then
    
    MYSQL=`which mysql`
    Q1="GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}' WITH GRANT OPTION;"
    Q2="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}"
    $MYSQL -uroot -e "$SQL"
    service mariadb restart
fi

  ##  Set root password
    
MYSQL=`which mysql`
    SQL="SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MARIADB_PASSWORD}');"
    $MYSQL -uroot -e "$SQL"

  ##  Allow root to connect from outside this location
SQL="CREATE USER 'root'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';"
$MYSQL -uroot -p$MARIADB_PASSWORD -e "$SQL"

echo "MariaDB Installation Ends"
