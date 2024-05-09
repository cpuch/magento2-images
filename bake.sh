#!/bin/bash
set -e

# Get commit id short
export GIT_COMMIT_SHORT=$(git rev-parse --short HEAD)

# Get variables from .env file
source .env

# Print build
docker buildx bake "$@" --print

# Build images
read -p "Continue? [y/N] "
case ${REPLY} in
#    y|Y) docker buildx bake "$@" --push ;;
    y|Y) docker buildx bake "$@" ;;
    n|N) exit 0 ;;
    *) exit 0 ;;
esac
