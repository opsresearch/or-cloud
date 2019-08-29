#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$HERE/.."
cd "$ROOT"
###################

export MODULE="$1"
export AWS_AMIS="$ROOT/aws/terraform/aws-amis-$MODULE.auto.tfvars"
export TEMP_FILE
TEMP_FILE="$(mktemp)"

rm -f "$AWS_AMIS"
cd "$ROOT/aws/packer"

packer build "$MODULE.json" | tee "$TEMP_FILE"
export AMI_ID
AMI_ID="$(grep 'us-east-1: ami-' "$TEMP_FILE" | tail -1 | sed 's/^.*ami-/ami-/')" 
rm -f "$TEMP_FILE"
cat<< EOF > "$AWS_AMIS"
aws_amis_$MODULE = {
  us-east-1 = "$AMI_ID"
}
EOF
