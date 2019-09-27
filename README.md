# nginx-release 

Completed for anynines homework task.

## Description

nginx-release provides a BOSH release for a Nginx web server that displays a 
static webpage protected by basic authentication. 

## Instructions

The release is deployed using Bosh-cli and BOSH lite as a director VM running
locally. 

The deployment can be tested by running `run-test.sh`

If BOSH Lite is not configured or installed see installation instructions below

## Installation

For automated deployment and testing of the release including installation and 
configuration of BOSH Lite v2 run the included `install-test.sh`.

Dependencies:

VirtualBox 5.1+    
bosh-cli #https://github.com/cloudfoundry/bosh-cli/releases

## Bonus 

go-webapp development branch contains an implementation of Nginx as a load
balancer that consumes links provided by the simple go-webapp BOSH release.

https://github.com/standthis/go-webapp-release

