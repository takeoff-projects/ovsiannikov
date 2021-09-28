#!/bin/bash
#it will destroy all resources described in main.tf

terraform plan -destroy
terraform destroy
