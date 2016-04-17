#!/usr/bin/env sh
service=$2
consul_url=$1
service_ids=$(curl -s -w '\n' $consul_url/v1/catalog/service/$service | jq .[].ServiceID | sed s/\"//g)
echo $service_ids
for service_id in $service_ids
do
	echo "$consul_url/v1/agent/service/deregister/$service_id"
	curl "$consul_url/v1/agent/service/deregister/$service_id"
done
