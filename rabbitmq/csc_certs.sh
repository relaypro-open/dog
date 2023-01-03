#!/bin/bash

HTTPD=`curl -A "Web Check" -sL --connect-timeout 3 -w "%{http_code}\n" "http://csc:8000/csc/register" -o /dev/null`
until [ "$HTTPD" == "200" ]; do
    printf '.'
    sleep 3
    HTTPD=`curl -A "Web Check" -sL --connect-timeout 3 -w "%{http_code}\n" "http://csc:8000/csc/register" -o /dev/null`
done

passkey=$(curl -s http://csc:8000/csc/register | jq -r .passkey)
certs=$(curl -s -d '{"fqdn": "rabbitmq", "passkey": "'$passkey'"}' http://csc:8000/csc/cert)
echo $certs | jq -r .server_key > /etc/rabbitmq/private/server.key
echo $certs | jq -r .server_crt > /etc/rabbitmq/certs/server.crt
echo $certs | jq -r .ca_crt >  /etc/rabbitmq/certs/ca.crt
