#!/bin/bash

set -ex

IMAGE_NAME="lucasvs/asterisk"
TAG="${1}"

REGISTRY="hub.docker.com"

docker build -t ${REGISTRY}/${IMAGE_NAME}:${TAG} -t ${REGISTRY}/${IMAGE_NAME}:latest .
docker push ${REGISTRY}/${IMAGE_NAME}