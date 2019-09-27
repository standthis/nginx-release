#!/bin/bash
set -e # -x

running=`vboxmanage list runningvms | wc -l`
if [ $running -ne 0 ]; then
    echo Saving state of currently running VMs
    vboxmanage list runningvms | sed -r 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} savestate
fi

pushd .


echo "-----> `date`: Install director VM if non-existent"
if [ ! -e ~/deployments/vbox ]; then
    git clone https://github.com/cloudfoundry/bosh-deployment ~/workspace/bosh-deployment
fi

mkdir -p ~/deployments/vbox
cd ~/deployments/vbox

[ -e creds.yml ] && mkdir backup && mv creds.yml backup
[ -e state.json ] && mv state.json backup

echo "-----> `date`: Create environment for BOSH-lite"
bosh create-env ~/workspace/bosh-deployment/bosh.yml \
  --state ./state.json \
  -o ~/workspace/bosh-deployment/virtualbox/cpi.yml \
  -o ~/workspace/bosh-deployment/virtualbox/outbound-network.yml \
  -o ~/workspace/bosh-deployment/bosh-lite.yml \
  -o ~/workspace/bosh-deployment/bosh-lite-runc.yml \
  -o ~/workspace/bosh-deployment/uaa.yml \
  -o ~/workspace/bosh-deployment/credhub.yml \
  -o ~/workspace/bosh-deployment/jumpbox-user.yml \
  --vars-store ./creds.yml \
  -v director_name=bosh-lite \
  -v internal_ip=192.168.50.6 \
  -v internal_gw=192.168.50.1 \
  -v internal_cidr=192.168.50.0/24 \
  -v outbound_network_name=NatNetwork

echo "-----> `date`: Set environemnt variables and credentials"
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh int ./creds.yml --path /admin_password`
bosh alias-env vbox -e 192.168.50.6 --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)
export BOSH_ENVIRONMENT=vbox

echo "-----> `date`: Set ip route for local route to VM"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo Linux detected
    # Add check if ip route exist
    EXIST=`ip route show 10.244.0.0/16 via 192.168.50.6 | wc -l`
    if [ $EXIST -ne 0 ]; then
        sudo ip route add 10.244.0.0/16 via 192.168.50.6 # Linux (using iproute2 suite)
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo Mac OS X detected
    sudo route add -net 10.244.0.0/16     192.168.50.6 # Mac OS X
else
    echo OS undetected! Please enter relevant command bellow.
    echo "sudo route add -net 10.244.0.0/16     192.168.50.6 # Mac OS X
    sudo ip route add   10.244.0.0/16 via 192.168.50.6 # Linux (using iproute2 suite)
    sudo route add -net 10.244.0.0/16 gw  192.168.50.6 # Linux (using DEPRECATED route command)
    route add           10.244.0.0/16     192.168.50.6 # Windows"
fi
    
echo "-----> `date`: Update Cloud config"
bosh -e vbox update-cloud-config ~/workspace/bosh-deployment/warden/cloud-config.yml

echo "-----> `date`: Upload stemcell"
bosh upload-stemcell --sha1 de5604ec6e12492959c9c2d86b57fb823be28135 \
  https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-xenial-go_agent?v=456.25

echo "-----> `date`: Delete previous deployment"
bosh -n -d nginx delete-deployment --force

echo "-----> `date`: Deploy"
popd 
bosh upload-release
bosh -d nginx deploy examples/nginx.yml

sleep 5
echo "-----> `date`: Test nginx authorization"
curl -u admin:supersecretpassword -i http://10.244.0.2

echo "-----> `date`: Delete deployments"
bosh -n -d nginx delete-deployment --force

echo "-----> `date`: Done"
