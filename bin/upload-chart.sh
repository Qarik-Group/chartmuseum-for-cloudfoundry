#!/bin/bash

function usage() { echo "USAGE: upload-chart.sh manifest-starkandwayne.yml tmp/vars.yaml path/to/chart/artifact.tgz"; exit 1; }

appmanifest=$1
[[ -f $appmanifest ]] || usage
shift

varsfile=$1
[[ -f $varsfile ]] || usage
shift

artifact=$1
[[ -f $artifact ]] || usage
shift

HELM_REPO_URI=https://$(cat $appmanifest | grep route: | head -n1 | awk '{print $3}')
HELM_REPO_USER=$(cat $varsfile | grep auth-user | awk '{print $2}')
HELM_REPO_PASS=$(cat $varsfile | grep auth-pass | awk '{print $2}')

echo "Uploading to $HELM_REPO_URI"

curl -v --data-binary "@${artifact}" \
  -u "${HELM_REPO_USER}:${HELM_REPO_PASS}" \
  ${HELM_REPO_URI}/api/charts
