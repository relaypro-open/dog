#!/bin/bash
NAME=$(http kong:8000/api/V2/hosts APIKEY:guest | jq -r .[0].name)
ansible-inventory -i dog.yml --host $NAME
