# nginx-release 

Completed for anynines homework task.

## Description

nginx-release provides a bosh release for nginx web server that displays a 
static webpage protected by basic authentication. 

## Instructions

The release can be deployed using Bosh-cli and tested with curl.

curl -u admin:supersecretpassword -i http://10.244.0.2

This command assumes setting of local route for accessing VM directly:

sudo route add -net 10.244.0.0/16     192.168.50.6 # Mac OS X  
sudo ip route add   10.244.0.0/16 via 192.168.50.6 # Linux 

If Bosh Lite is not configured or installed see installation instructions below

## Installation

For automated deployment and testing of the release including installation and 
configuration of BOSH Lite v2 run the included install-test.sh

Dependencies:

VirtualBox 5.1+    
bosh-cli #https://github.com/cloudfoundry/bosh-cli/releases

## Bonus 

go-webapp development branch contains an implementation of nginx as a load
balancer that consumes links provided by the simple go-webapp BOSH release

https://github.com/standthis/go-webapp-release

 


