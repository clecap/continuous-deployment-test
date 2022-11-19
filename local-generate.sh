#!/bin/bash

# generate a local docker image for the docker context in containers/${CONTAINER_NAME}/src
 

IMAGE_NAME=$1

# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t ${IMAGE_NAME} ${DIR}/containers/${IMAGE_NAME}/src

