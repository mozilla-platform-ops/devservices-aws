#!/bin/bash
#
set -euf -o pipefail

tfenv="$(basename "$(pwd)")"

# Set up remote state
terraform init \
    -backend-config="key=tf_state/${tfenv}/terraform.tfstate" \

# Update modules
terraform get
