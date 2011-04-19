#!/bin/bash
echo "Queue Info: "
echo "name durable messages_ready messages_unacknowledged consumer_count memory" | column -t
echo "------------------------------------------------------------------"
sudo rabbitmqctl -q list_queues -p /$1 name durable messages_ready messages_unacknowledged consumers memory | sort | column -t 
#echo "------------------------------------------------------------------"
#echo "Connection Info: "
#echo "vhost user IP state channels timeout client_properties" | column -t
#echo "------------------------------------------------------------------"
#sudo rabbitmqctl -q list_connections vhost user address state channels timeout client_properties | column -t 
#echo "------------------------------------------------------------------"
#echo "Channels:"
#echo "number user vhost transactional consumer_count messages_unacknowledged prefetch_count" | column -t
#echo "------------------------------------------------------------------"
#sudo rabbitmqctl -q list_channels number user vhost transactional consumer_count messages_unacknowledged prefetch_count
#echo "------------------------------------------------------------------"
#echo "Consumers:"
#echo " queue connection_pid consume_tag acks_expected" | column -t
#echo "------------------------------------------------------------------"
#sudo rabbitmqctl -q list_consumers -p /$1 | column -t 
#echo "------------------------------------------------------------------"
#echo "Exchange Info: "
#echo " name type durable auto_delete"
#echo "------------------------------------------------------------------"
#sudo rabbitmqctl -q list_exchanges -p /$1 name type durable auto_delete | sort | column -t
#echo "------------------------------------------------------------------"