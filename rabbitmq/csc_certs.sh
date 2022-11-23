#!/bin/bash
certs=$(curl -s -d '{"fqdn": "rabbitmq"}' http://csc:9001/2015-03-31/functions/myfunction/invocations)
echo $certs | jq -r .server_key > /etc/rabbitmq/private/server.key
echo $certs | jq -r .server_crt > /etc/rabbitmq/certs/server.crt
echo $certs | jq -r .ca_crt >  /etc/rabbitmq/certs/ca.crt
