#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$HERE/.."
cd "$ROOT"
###################

./bin/packer.sh bastion &
./bin/packer.sh control &
./bin/packer.sh cluster &
wait
./bin/terraform.sh init
./bin/terraform.sh apply
