#!/usr/bin/env bash

declare -a nodeLabels=("master" "amf" "smf" "upf" "udsf" "ausf" "nrf" "pcf" "udm")
declare -a workerNodes=("02" "08" "09" "11" "12" "14" "16" "17" "18")

arrayIndex=0
for nodeNum in "${workerNodes[@]}"
do	
	node=cap$nodeNum
	echo ""
	echo "Labelling Node - $node"
	echo ""
    kubectl label --overwrite nodes $node kubernetes.io/pcs-nf-type=${nodeLabels[arrayIndex]}
	echo ""
	echo "Finished Labelling Node - $node"
    echo ""
    arrayIndex=$((arrayIndex + 1))
done