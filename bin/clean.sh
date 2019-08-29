#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$HERE/.."
cd "$ROOT"
###################

rm -rf ./aws/terraform/.terraform
rm -rf ./aws/terraform/aws-amis-*.tfvars
rm -rf ./aws/terraform/terraform.tfstate
rm -rf ./aws/terraform/terraform.tfstate.backup
