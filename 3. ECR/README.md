# Amazon Elastic Container Registry
Using terraform to create an ecr repository to store, manage and deploy container images this is a handy feature to have when it comes to using Docker. When using docker you will have diffrent versions to fall back on if a new feature on an image does not fucntion correctly or if somthing happens, having an ecr repository will allow you to safely store your images and quickly fallback to a version you desire.

The set up is very basic and has no requirements in order for it to be created. Follow the commands below to apply the resource:

* terraform init

* terraform plan -out ecr.tfplan

* terrafrom apply ecr.tfplan
