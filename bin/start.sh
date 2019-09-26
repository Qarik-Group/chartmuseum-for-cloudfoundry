#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd $ROOT

platform() {
    if [ "$(uname)" == "Darwin" ]; then
        echo "darwin"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        echo "linux"
    fi
}

[[ -f ./bin/chartmuseum-$(platform) && $(./bin/chartmuseum-$(platform) --version) ]] || {
  echo "Downloading chartmuseum for $(platform)..."
  curl -L -o ./bin/chartmuseum-$(platform) \
    https://s3.amazonaws.com/chartmuseum/release/latest/bin/$(platform)/amd64/chartmuseum
  chmod +x ./bin/chartmuseum-$(platform)
}

./bin/chartmuseum-$(platform) --version
./bin/chartmuseum-$(platform) "$@"

