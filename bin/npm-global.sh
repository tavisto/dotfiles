#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not installed. Install it with your package manager."
  exit 1
fi

if [ ! -f package.json ]; then
  echo "package.json not found in current directory."
  exit 1
fi

deps=$(jq -r '.dependencies | keys[]' package.json)

if [ -z "$deps" ]; then
  echo "No dependencies found in package.json."
  exit 0
fi

echo "Installing global packages: $deps"
npm install -g $deps
