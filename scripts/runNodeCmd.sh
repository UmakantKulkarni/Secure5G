#!/usr/bin/env bash

# Initial config:
#       apt-get -y update && apt-get -y upgrade && apt-get -y update && apt-get -y dist-upgrade
#       visudo
#       ukulkarn ALL = NOPASSWD : ALL
#       sed -i '/PermitRootLogin/s/.*/PermitRootLogin yes/' /etc/ssh/sshd_config
#       systemctl restart ssh
#       sed -i '/xterm-color/s/.*/    xterm-color|*-256color) color_prompt=yes;;/' ~/.bashrc
#       source ~/.bashrc
#       apt-get -y install vim git curl wget net-tools sshpass
#       passwd root
#       echo "export MYPASSWD=" >> ~/.bashrc
#       ./run_node_cmd.sh 1 'hostname' 01 02 08 09 10 11 12 14 16 17 18 21 27 28 31

parallel=$1
cmd="$2"

echo ""
if [ $1 = "1" ]; then
    echo "Executing commands parallely"
else
    echo "Executing commands serially"
fi
echo ""


for i in "${@:3}"
do
    node=cap$i.cs.purdue.edu
    echo ""
    echo "Executing command on Node - $node"
    echo ""
    if [ $1 = "1" ]; then
        sshpass -p $MYPASSWD ssh -o StrictHostKeyChecking=no root@$node "$cmd" &
    else
        sshpass -p $MYPASSWD ssh -o StrictHostKeyChecking=no root@$node "$cmd"
    fi
    echo ""
    echo "Finished executing command on Node - $node"
    echo ""
done
echo "Waiting for commands to finish executing"
echo ""
wait
