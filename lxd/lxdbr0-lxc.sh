#!/bin/bash

# create lxd/lxc container with static ip connected via default lxd network
# input:
# - subnetName eg 'microk8s'
# - hostIp eg '10'
# - networkId eg '192.168.2'

# input
subnetName=$1
networkId=$2
hostId=$3

echo "subnetName=$subnetName networkId=$networkId hostId=$hostId"

echo "setting container name"
lxc_container="$subnetName-$hostId"
# parentBridge="wlp2s0"
echo "setting image name"
lxc_image="ubuntu:22.04"
# init setup file
initSetup="reset_environment.sh"
initUser="setup_initial_user.sh"
# preInstall=microk8s-preps.sh
# postInstall=microk8s-postinstallation.sh

# sh $preInstall
# dedicated to lxd container with specific ip to host microk8s
echo "creating container"
lxc stop $lxc_container
sleep 5
lxc delete $lxc_container
sleep 5
lxc init $lxc_image $lxc_container
sleep 20
echo "setting container static ip"
lxc network attach lxdbr0 $lxc_container eth0 eth0
lxc config device set $lxc_container eth0 ipv4.address $networkId.$hostId
sleep 5
lxc start $lxc_container
sleep 20
lxc list

lxc file push $initSetup $lxc_container/tmp/
lxc file push $initUser $lxc_container/tmp/
lxc exec $lxc_container -- sh /tmp/$initSetup
lxc exec $lxc_container -- sh /tmp/$initUser
