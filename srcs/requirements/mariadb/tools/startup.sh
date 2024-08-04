# Creates folders to store the PID files
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 777 /var/run/mysqld

# Check if the database already exists
if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    exec mysqld_safe --bind-address=0.0.0.0
fi

# Runs this script to prepare the database environment for first use 
# by creating the required system databases and tables, 
# such as mysql, information_schema, and performance_schema. 
mariadb-install-db

# Runs this script to enhance the security:
# Do not change to unix socket
# Set a root password
# Remove anonymous users
# Allow root login remotely
# Remove test databases and access to them
# Reload privilege tables
service mariadb start
mysql_secure_installation << EOF

n
Y
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
Y
n
Y
Y
EOF
# Creates the database and user
mysql -u $MYSQL_ROOT_USER -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mysql -u $MYSQL_ROOT_USER -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -u $MYSQL_ROOT_USER -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
mysql -u $MYSQL_ROOT_USER -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
service mariadb stop

# Runs this command to replace this script by mysqld_safe command:
# Is a wrapper script provided by MySQL and MariaDB to start the mysqld daemon
# It adds some safety features like restarting the server if it crashes and logging errors to a file
# --bind-address=0.0.0.0 tells the MySQL server to bind to all available network interfaces.
# it allows MySQL to accept connections from any IP address, effectively making it accessible from remote machines.
exec mysqld_safe --bind-address=0.0.0.0