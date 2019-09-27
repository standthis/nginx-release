#!/bin/bash

set -e # -x

echo "-----> `date`: Upload stemcell"
bosh upload-stemcell --sha1 de5604ec6e12492959c9c2d86b57fb823be28135 \
  https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-xenial-go_agent?v=456.25

echo "-----> `date`: Delete previous deployment"
bosh -n -d nginx delete-deployment --force

echo "-----> `date`: Get go-webapp release"
if ! bosh releases | grep go-webapp; then
    git clone https://github.com/standthis/go-webapp-release
    cd go-webapp-release
    bosh upload-release
    cd ..
    rm -rf go-webapp-release
fi

echo "-----> `date`: Deploy"
( set -e; bosh -n -d nginx deploy ../examples/nginx.yml )

echo "-----> `date`: Run test errand"
bosh -n -d nginx run-errand nginx

echo "-----> `date`: Delete deployments"
bosh -n -d nginx delete-deployment

echo "-----> `date`: Done"
