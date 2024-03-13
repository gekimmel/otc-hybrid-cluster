#!/bin/sh
# check preliminaries for lsf cluster
# use: copy to /data and execute from lsf-master as root with check_lsf_hosts_all.sh

LSFMASTER="lsf-master"

echo "host: $HOSTNAME  --------------------------------------"

LSF_HOSTS=$(grep lsf /etc/hosts | awk '{ print $2 }')

echo $LSF_HOSTS

if [ $HOSTNAME == $LSFMASTER ]; then
  echo "check ssh connectivity -----"
  for HOST in $LSF_HOSTS; do
    echo -n "$HOST "
    ssh $HOST uptime
  done
  echo "check port reachability -----"
  for HOST in $LSF_HOSTS; do
    echo "to host $HOST"
    nmap -p 7869,6891,6882,6878,6881 $HOST | grep "/tcp"
  done
fi

echo "check DNS -----"
for HOST in $LSF_HOSTS; do
  echo -n "$HOST "
  dig +short +search $HOST
done

echo "check ping -----"
for HOST in $LSF_HOSTS; do
  echo -n "$HOST "
  ping -c 1 -w 1 $HOST >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "OK"
  else
    echo "FALSE"
  fi
done

echo "check NFS directory -----"
ls -d /data/lsf_download

echo "check installed packages -----"
rpm -qa ed
rpm -qa libnsl

echo "check sudoers -----"
cat /etc/lsf.sudoers

echo "check lsf.conf parameters -----"
grep ^LSF_ /usr/share/lsf/conf/lsf.conf | sort

echo "check secondary lsf.conf -----"
ls -l /usr/local/lsf/conf/lsf.conf

echo "list local ports -----"
netstat -tulpn | grep -E "mbatchd|/res|sbatchd|lim" | awk '{ print $4 }' | sort

echo "check port reachability to $LSFMASTER -----"
nmap -p 7869,6891,6882,6878,6881 $LSFMASTER | grep "/tcp"

