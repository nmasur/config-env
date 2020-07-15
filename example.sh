#!/bin/sh

# Download static binary and unzip
curl -L https://github.com/nmasur/config-env/releases/download/latest/config-env.zip --output config-env.zip
unzip config-env.zip
rm config-env.zip

# Build docker image (copies static binary)
docker build -t config-env-example -f example.Dockerfile ./

# Run docker container, adding environment variables if not already available
# AWS creds can be provided from credentials file, env variables, or IAM role from EC2 or other system
docker run --rm -e APPLICATION=pd-store -e ENVIRONMENT=production -e VERSION=blue -v $HOME/.aws/credentials:/root/.aws/credentials config-env-example
