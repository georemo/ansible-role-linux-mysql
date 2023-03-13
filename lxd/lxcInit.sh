#!/bin/bash

networkName="cd-sql-cluster"
networkId="192.168.2"
remoteUser="devops"

# create containers
for i in 0 1 2
do
sh lxdbr0-lxc.sh "$networkName" "$networkId" "11$i"
done

# ssh-copy-id
for i in 0 1 2
do
echo "Looping ... number $i"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "cd-sql-cluster-11$i"
ssh-keygen -f "/home/emp-07/.ssh/known_hosts" -R "$networkId.11$i"
sshpass -p "yU0B14NC1PdE" ssh-copy-id "$remoteUser@$networkName-11$i"
sshpass -p "yU0B14NC1PdE" ssh-copy-id "$remoteUser@$networkId.11$i"
done

# build cluster
echo "sending build_cluster.js file"
lxc file push build_cluster.js cd-sql-cluster-110/tmp/
echo "sending init_cluster.js file"
lxc file push init_cluster.js cd-sql-cluster-110/tmp/

# ansible-playbook -i hosts.ini install-debian-alt.yml --extra-vars "ansible_sudo_pass=yU0B14NC1PdE"
