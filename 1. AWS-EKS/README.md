# AWS EKS Creation
Here is a basic setup for a AWS Cluster using terraform scrips to automate the process. The results of using these will build you an EKS Cluster with 2 worker nodes, 2 public subnets, security groups and roles assigned to the nodes and cluster.

# Start
You will need to first setup your AWS Credentials using awscli commands on your terminal, the command you will use is:
  aws configure
There you can take your access keys and secret keys provided by aws and have it stored within your system instead of on the scripts. This will be stored as a credentials file in your .aws folder and will communicate with terraform when you start running the scripts. 

After you have configured your aws go into the directory of the terraform scripts and start with the following command:
  terraform init
This command sets up terraform within your directory as you will see its created a folder where it will store and contain the versions of providers being used and modules, plugins and configurations files. To keep the structure as clean and easy to follow as possible I will be using terraforms module structure, which will makes things easier to follow.  

Next do a Terraform plan which wont install or do anything but setup what resources that are going to be installed when we do the apply. Plans are required and saving them is recommended so that when terraform runs it knows what resources are being installed/deleted/updated.
  terraform plan -out aws_eks.tfplan
The first two commands will find any errors or permissions needed for you to fix before doing the apply, In my experiance terrform will find about 90% of any forseen errors that could cause harm when applying the plan. 

Once everything is ready begin the install of your resources with the following command: 
  terraform apply aws_eks.tfplan
Terraform will then begin installing the resources based off the plan you created, it should be noted that this script will take over 10 mins plus or minus 1-2 minutes. This is because the EKS itself takes 10 minutes to actually create the cluster on AWS. 

If you have access you can go onto the AWS console on thier site and see the resources you are creating. 

               *Note as of now you have only created the cluster and workers nodes but not connected them yet
To connect the nodes with the cluster use the following commands below: 
  terraform output kubeconfig > C:Users/<profile here>/.kube/config
  terraform output config_map_aws_auth > aws-auth.yaml
  kubectl apply -f aws-auth.yaml

You will have connected the worker nodes to your cluster and if you installed kubectl onto your system you can see your cluster and nodes via the command:
  kubectl get svc 
  kubectl get nodes
  
  
  
