#!/bin/bash
NAME=$(curl -s kong:8000/api/V2/hosts -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIwZDY3NGRhNGFjNzYxMWVkYThmNzhmNzdmYTUyMWI2ZSJ9.PASNsZCTJihOO6ffBO2g-7N-OQWVI5KsnP7bq5Pi3aE" | jq -r .[0].name) 
echo "Fist host found: $NAME"
ansible-inventory -i environments/docker/ --host $NAME
