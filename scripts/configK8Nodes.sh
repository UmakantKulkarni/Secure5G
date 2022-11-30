#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
	echo "Expected at least 1 CLI argument - Interface name"
    exit 1
fi

intf="$1"
masterNode="02"
declare -a workerNodes=("08" "09" "11" "12" "14" "16" "17" "18")
declare -a ranNodes=("21" "27")

#https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/
#https://computingforgeeks.com/install-mirantis-cri-dockerd-as-docker-engine-shim-for-kubernetes/
#https://www.tutorialworks.com/difference-docker-containerd-runc-crio-oci/

#cri_socket="unix:///var/run/crio/crio.sock"
#cri_socket="unix:///run/containerd/containerd.sock"
#cri_socket="unix:///run/cri-dockerd.sock"

echo ""
echo "Configuring Master Node"
echo ""

mcmd="cd /opt/Secure5G/ && git pull && bash /opt/Secure5G/scripts/configMasterNode.sh $intf"
sshpass -p $MYPASSWD ssh -o StrictHostKeyChecking=no root@cap$masterNode "$mcmd"
kjoincmdorig="kubeadm token create --print-join-command"
kjoincmd=$(sshpass -p $MYPASSWD ssh -o StrictHostKeyChecking=no root@cap$masterNode "$kjoincmdorig")

echo ""
echo "Finished Configuring Master Node. Sleep for 30 seconds..."
echo ""

sleep 30

echo ""
echo "Configuring Worker Nodes with command - $kjoincmd"
echo ""


wcmd="cd /opt/Secure5G/ && git pull && bash /opt/Secure5G/scripts/configWorkerNode.sh \"$kjoincmd\" && exit"
for nodeNum in "${workerNodes[@]}"
do	
	node=cap$nodeNum
	echo ""
	echo "Configuring Node - $node"
	echo ""
	sshpass -p $MYPASSWD ssh -o StrictHostKeyChecking=no root@$node "$wcmd"
	echo ""
	echo "Finished Configuring Worker Node - $node"
    echo ""
done

echo ""
echo "Finished Configuring Worker Nodes"
echo ""

echo ""
echo "Started Configuring RAN Nodes"
echo ""

rcmd="cd /opt/Secure5G/ && git pull && bash /opt/Secure5G/scripts/configRanNode.sh && exit"
for nodeNum in "${ranNodes[@]}"
do	
	node=cap$nodeNum
	echo ""
	echo "Configuring Node - $node"
	echo ""
	sshpass -p $MYPASSWD ssh -o StrictHostKeyChecking=no root@$node "$rcmd"
	echo ""
	echo "Finished Configuring RAN Node - $node"
    echo ""
done

echo ""
echo "Finished Configuring RAN Nodes"
echo ""
