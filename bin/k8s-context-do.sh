#!/bin/bash


while getopts ":c:" opt; do
  case ${opt} in
    c )
      CONTEXT="--context=${OPTARG}"
      ;;
    \? )
      usage
      ;;
    : )
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [-c <context>] <label-key>"
  exit 1
fi

LABEL_KEY=$2


$HOME/bin/k8s-pods-by-node.sh "$LABEL_KEY" --context "$CONTEXT"
