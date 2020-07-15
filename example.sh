#!/bin/sh

curl -L https://github.com/nmasur/config-env/releases/download/latest/config-env.zip --output config-env.zip
unzip config-env.zip
rm config-env.zip
docker build -t config-env-example -f example.Dockerfile ./
docker run --rm -e APPLICATION=pd-store -e ENVIRONMENT=production -e VERSION=blue -v $HOME/.aws/credentials:/root/.aws/credentials config-env-example
