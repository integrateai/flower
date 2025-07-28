#!/bin/bash

# PRE_REQUISITES:
# pip install twine
# Run gimme-aws-creds

# repository = integrateai_internal | integrateai
repository=integrateai_internal

FLWR_Name=$(ls -1 ./dist/iai_flwr-*.tar.gz)
FLWR_Name_Wheel=$(ls -1 ./dist/iai_flwr-*.whl)

# Login to Code artifact, using twine
export AWS_REGION=us-east-1
export TWINE_USERNAME=aws
# export TWINE_PASSWORD=`aws codeartifact get-authorization-token --domain iai --domain-owner 919740802015 --query authorizationToken --output text`
# export TWINE_REPOSITORY_URL=`aws codeartifact get-repository-endpoint --domain iai --domain-owner 919740802015 --repository $repository --format pypi --query repositoryEndpoint --output text`
# Upload using twine
twine upload --repository codeartifact $FLWR_Name
twine upload --repository codeartifact $FLWR_Name_Wheel
