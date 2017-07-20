#!/bin/bash
#
set -euf -o pipefail

tfenv="$(basename "$(pwd)")"

# Set up remote state
terraform remote config -backend=s3 \
    -backend-config="bucket=moz-devservices" \
    -backend-config="key=tf_state/${tfenv}/terraform.tfstate" \
    -backend-config="region=us-east-1"

# Update modules
terraform get
