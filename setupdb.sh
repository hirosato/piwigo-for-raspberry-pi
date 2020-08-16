#!/bin/sh
if [ ! -d "/run/mysqld" ]; then
	  mkdir -p /run/mysqld
	    chown -R mysql:mysql /run/mysqld
fi
if [ ! -e /usr/my.cnf ]; then
	  cat << EOF > /usr/my.cnf
[mysqld]
datadir=/var/lib/mysql
log-bin = /var/lib/mysql/mysql-bin
port = 3306
user = mysql
symbolic-links=0
character-set-server = utf8
pid-file=/run/mysqld/mysqld.pid
EOF
  chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --user=mysql
      nohup /bin/sh /usr/bin/mysqld_safe \
	          --datadir=/var/lib/mysql \
		      --socket=/run/mysqld/mysqld.sock \
		          --pid-file=/run/mysqld/mysqld.pid \
			      --basedir=/usr \
			          --user=mysql \
				      --skip-grant-tables \
				          --skip-networking &
        while :
		  do
			      [ -r /run/mysqld/mysqld.pid ] || continue
			          if ps -ef | grep -q $(cat /run/mysqld/mysqld.pid) ; then
					          break
						      fi
						          sleep 10
							    done
							      cat << EOF > /tmp/setupdb.sql
USE mysql;
UPDATE mysql.user SET Password=PASSWORD('piwigo') WHERE User='root';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'piwigo';
FLUSH PRIVILEGES;
EOF
  /usr/bin/mysql < /tmp/setupdb.sql
    cat << EOF > /tmp/createdb.sql
CREATE DATABASE piwigo DEFAULT CHARACTER SET utf8mb4;
EOF
  /usr/bin/mysql -uroot -ppiwigo < /tmp/createdb.sql
    kill `cat /run/mysqld/mysqld.pid`
      sleep 10
				  fi
				  exec /usr/bin/mysqld --defaults-file=/usr/my.cnf --console --user=mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
