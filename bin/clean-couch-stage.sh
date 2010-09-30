#!/bin/bash
echo "Clearing index: "
curl -X DELETE 	"http://bpcdstage001.co1:5984/wmg-delivery-index"
curl -X PUT		"http://bpcdstage001.co1:5984/wmg-delivery-index"

echo "Clearing status: "
curl -X DELETE 	"http://bpcdstage001.co1:5984/wmg-delivery-status"
curl -X PUT 	"http://bpcdstage001.co1:5984/wmg-delivery-status"