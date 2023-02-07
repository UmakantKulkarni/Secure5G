#!/usr/bin/env bash

mydir=/opt

cd $mydir
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

cd $mydir
wget https://github.com/davidfoerster/aptsources-cleanup/releases/download/v0.1.7.5.2/aptsources-cleanup.pyz
chmod a+x aptsources-cleanup.pyz
yes | ./aptsources-cleanup.pyz -y

apt-get -y update && apt-get -y upgrade && apt-get -y update && apt-get -y dist-upgrade
