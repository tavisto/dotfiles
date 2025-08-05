#!/bin/bash

npm ls -g --depth=0 --json \
  | jq '{name:"global-packages",version:"1.0.0",dependencies: (.dependencies | map_values(.version))}' \
  > package.json
