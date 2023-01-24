#!/bin/bash -x 
sleep 15
cd /terraform/ && terraform init
cd /terraform && dog-import docker /terraform/dog/ "docker_"
chmod u+x /terraform/dog/*.sh
/terraform/dog/group_import.sh
/terraform/dog/host_import.sh
/terraform/dog/profile_import.sh
/terraform/dog/service_import.sh
/terraform/dog/zone_import.sh
cd /terrraform
terraform apply -auto-approve
