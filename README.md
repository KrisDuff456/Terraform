# Terraform
Here are some simple terraform scripts to create the following below in AWS:
  1. EKS creation 
  2. NGINX 
  3. ECR
  4. EFS
  5. Terraform State and S3 Bucket
  6. AWS RDS

# Requirments
You will need to have the required software installed on your system either on Linux or Windows: 
  1. You will need to have the latest version of terraform installed
  2. You will need to have the awscli installed
  3. You will need to have the latest version of Kubectl installed 
  4. You will need to install AWS IAM Authenticator installed 
  
# AWS Policys for User
Make sure the user your using has these policys attached to them so that they can run the terraform scripts
  * AutoScalingFullAccess
	
  * AmazonEKSClusterPolicy
	
  * AmazonEKSWorkerNodePolicy
	
  * AmazonVPCFullAccess
	
  * AmazonEKSServicePolicy
	
  * AmazonEKS_CNI_Policy
	
  * AmazonEC2FullAccess
  
  * AmazonRDSFullAccess
