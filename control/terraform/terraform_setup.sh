#!/bin/bash -x 
#sleep 15
export DOG_API_TOKEN=$(cat $DOG_API_TOKEN_FILE)
export TF_VAR_dog_api_token_docker=$(cat $TF_VAR_dog_api_token_docker_FILE)
#mv /tmp/dog-import/host.tf /terrraform/dog/
chmod u+x /terraform/dog/*.sh
#/terraform/dog/host_import.sh
#cd /terrraform
terraform apply -auto-approve
