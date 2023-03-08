#!/bin/bash

hostId="112"
networkId="192.168.2"
lxc_container="cd-sql-cluster-$hostId"
lxc_image="ubuntu:22.04"
initSetup="reset_environment.sh"
initUser="setup_initial_user.sh"

lxc stop $lxc_container
sleep 5
lxc delete $lxc_container
sleep 5
lxc init $lxc_image $lxc_container
sleep 20
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