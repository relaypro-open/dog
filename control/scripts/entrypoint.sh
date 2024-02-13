#!/bin/bash
cd /terraform
terraform init
/bin/bash -c "/terraform/terraform_setup.sh" && /bin/bash -c "sleep infinity"
