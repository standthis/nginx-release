#!/bin/bash

set -e # -x

echo "-----> `date`: Upload stemcell"
bosh upload-stemcell --sha1 de5604ec6e12492959c9c2d86b57fb823be28135 \
  https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-xenial-go_agent?v=456.25

echo "-----> `date`: Delete previous deployment"
bosh -n -d nginx delete-deployment --force

echo "-----> `date`: Deploy"
( set -e; bosh -n -d nginx deploy ../examples/nginx.yml )

echo "-----> `date`: Run test errand"
bosh -n -d nginx run-errand nginx

echo "-----> `date`: Delete deployments"
bosh -n -d nginx delete-deployment

echo "-----> `date`: Done"
