# nginx-release 

Completed for anynines homework task.

## Description

nginx-release provides a BOSH release for a Nginx web server that displays a 
static webpage protected by basic authentication. 

## Instructions

The release is deployed using [Bosh-cli][1] 

The deployment can be tested by running `run-test.sh`

If BOSH Lite is not configured or installed see installation instructions below

## Installation

For automated deployment and testing of the release including installation and 
configuration of BOSH Lite v2 as a director VM running locally use `install-test.sh`.

Dependencies:

VirtualBox 5.1+    
[bosh-cli][1]

[1]:https://github.com/cloudfoundry/bosh-cli/releases

## Bonus 

go-webapp development branch contains an implementation of Nginx as a load
balancer that consumes links provided by the simple [go-webapp][2] BOSH release.

[2]:https://github.com/standthis/go-webapp-release

## Bonus 

go-webapp development branch contains an implementation of nginx as a load
balancer that consumes links provided by the simple go-webapp BOSH release

https://github.com/standthis/go-webapp-release

 


