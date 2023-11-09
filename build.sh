#!/bin/bash

set -eu

version=$1
tag="jiro4989/build-rpm-action:$version"
docker build --no-cache -t "$tag" .
docker push "$tag"
