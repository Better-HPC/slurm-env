#!/bin/bash

set -eo pipefail

echo ">> Starting MySQL server"
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &
while ! mysqladmin ping --silent; do
    sleep 1
done

echo -e "\n>> Populating Slurm database"
mysql -NBe "
    CREATE DATABASE IF NOT EXISTS slurm_acct_db;
    CREATE USER IF NOT EXISTS 'slurm'@'localhost';
    GRANT USAGE ON *.* TO 'slurm'@'localhost';
    GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@'localhost';
    FLUSH PRIVILEGES;"
echo "Database \`slurm_acct_db\` is populated."

echo -e "\n>> Starting munge"
/usr/sbin/create-munge-key -f
/usr/sbin/runuser -u munge -- /usr/sbin/munged
