#!/bin/bash
#it will create all resources described in main.tf

#########variables
ProjectID="roi-takeoff-user72"
##################
if [ $GOOGLE_CLOUD_PROJECT == "" ]; then
	export GOOGLE_CLOUD_PROJECT=$ProjectID
fi
echo "ProjectID ="$GOOGLE_CLOUD_PROJECT

gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/level1v2

#cd terraform
#uncomment for the first start
#gcloud datastore databases create --region=us-central
terraform init && terraform apply -auto-approve

gcloud endpoints services deploy openapi-run.yaml

