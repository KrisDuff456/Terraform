# NGINX SERVICE 
There are two ways in which to create the Nginx service "2.1 Terraform-Kubectl" or "2.2 Terraform-Nginx" both will create a the service which will appear on AWS as a loadbalancer. AWS creates a loadbalancer due to the type set in the kubernetes resources, this can cause some confusion for thoes who are not familiar with both AWS loadbalancer and kubernetes service.

The servie will be a pod so you will be required to have a cluster and worker nodes up and ready. 

# 2.1 Terraform-Kubectl
This version is using a null resource to provision the nginx yaml files, a null resource is simple a terraform resource which is empty and mainly used for commands or to setup waits(depends_on). This method has worked best in my experiance as AWS and kubernetes would accept the service and function more properly than the second option. 

Use the following commands to apply the service:

* terraform init

* terraform plan -out nginx.tfplan

* terraform apply nginx.tfplan 

After applying the terraform commands switch to kubectl and follow: 

* kubectl get svc --namespace=ingress-nginx

You can view and see the nginx if you want the ip address for the balancer use nslookup on the external ip address

*Note you will need to use kubectl delete "kubectl delete svc ingress-nginx -n ingress-nginx" first then "terraform destroy" in order to successfully delete the service.

# 2.2 Terraform-Nginx
This version will be using the kubernetes provider resource to create the nginx service, while I have used this structure has worked for me I found that AWS and kubernetes have difficulty in connecting the balancer which results in unhealthy instances and complications. 
The following commands will create an nginx service balancer: 

* terraform init

* terraform plan -out nginx.tfplan

* terraform apply nginx.tfplan 

Unlike the previous option you can use the terraform destroy without having to use kubectl first. 
