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

# Assigning the input parameters to variables
LABEL_KEY=$1

# Get the list of nodes with the specific label
NODES=$(kubectl get nodes -l "${LABEL_KEY}" -o jsonpath='{.items[*].metadata.name}' "$CONTEXT")

# Iterate over each node and get the pods running on it, excluding DaemonSets
for NODE in $NODES; do
  echo "Node: $NODE"
  PODS=$(kubectl get pods --all-namespaces --field-selector spec.nodeName="$NODE" -o json "$CONTEXT")
  echo $PODS | jq -r '.items[] | select(.metadata.ownerReferences[]?.kind != "DaemonSet") | [.metadata.namespace, .metadata.name] | @tsv' | column -t
  echo
done
