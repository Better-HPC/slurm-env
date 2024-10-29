#!/bin/bash

set -eo pipefail

# Wait for a command exit
wait() {
    local cmd="$1"
    local timeout=30
    local elapsed=0
    while ! eval "$cmd"; do
        sleep 1
        elapsed=$((elapsed + 1))
        if [ "$elapsed" -ge "$timeout" ]; then
            echo "Error: Command timed out after ${timeout} seconds."
            return 1
        fi
    done
}

echo "Launching services..."
echo "(1/7) Starting MySQL server"
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' > /dev/null &
wait "mysqladmin ping --silent"

echo "(2/7) Populating Slurm database"
mysql -NBe "
    CREATE DATABASE IF NOT EXISTS slurm_acct_db;
    CREATE USER IF NOT EXISTS 'slurm'@'localhost';
    GRANT USAGE ON *.* TO 'slurm'@'localhost';
    GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@'localhost';
    FLUSH PRIVILEGES;"

echo "(3/7) Starting munge"
/usr/sbin/create-munge-key -f > /dev/null
/usr/sbin/runuser -u munge -- /usr/sbin/munged

echo "(4/7) Creating API key"
install -d -m 0755 -o slurm -g slurm /var/slurmstate
dd if=/dev/random of=/var/slurmstate/jwt_hs256.key bs=32 count=1 status=none
chown slurm:slurm /var/slurmstate/jwt_hs256.key
chmod 0600 /var/slurmstate/jwt_hs256.key

echo "(5/7) Starting slurmdbd"
/usr/sbin/slurmdbd
sleep 3

echo "(6/7) Starting slurmctld"
/usr/sbin/slurmctld -c
wait "scontrol ping | grep -q 'UP'"

echo "(7/7) Starting slurmrestd"
SLURM_JWT=daemon /usr/sbin/slurmrestd -u slurm 0.0.0.0:6820 &

echo "System ready"
exec "$@"
