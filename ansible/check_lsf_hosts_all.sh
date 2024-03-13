#!/bin/sh
# connect to all lsf hosts and run check script

for HOST in $(grep lsf /etc/hosts | awk '{ print $2 }'); do
  echo "$HOST"
  ssh $HOST /data/check_lsf_hosts.sh >check_lsf_hosts.${HOST}.log 2>&1
done

