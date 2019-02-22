###########################################
				# VARIABLES #
###########################################

variable "aws_region" {
		default = "eu-west-1"
		type	= "string"
		description = "Region you wish to deploy in"
}

variable "cluster_name" {
		default = "terraform_eks_cluster"
		type	= "string"
		description = "Name of your cluster"
}

variable "worker_name" {
		default = "terraform_worker_node"
		type	= "string"
		description = "Name of your worker"
}


# Virtual Private Cloud # 
variable "vpc_subnet_cidr" {
		default = "10.0.0.0/16"
		type	= "string"
		description = "VPC subnet cidr block which will be used for your subnets"
}

variable "subnet_count" {
		default = "2"
		type	= "string"
		description = "Number of public subnets we will have"
}
# EC2 Instance type #
variable "worker_instance_type" {
		default = "t2.mirco"
		type	= "string"
		description = "EC2 Instance type i.e. t2.mirco, c5.xlarge, c5.large..."
}



# Autoscaling of the worker nodes #
variable "max_count" {
		default = "2"
		type	= "string"
		description = "Autoscaling of the worker nodes or max number of EC2 instnaces we will have up"
}
variable "min_count" {
		default = "1"
		type	= "string"
		description = "Autoscaling of the worker nodes or min number of EC2 instances we will have up"
}
variable "desired_capacity" {
		default = "2"
		type	= "string"
		description = "Autoscaling desired number of EC2 instances we wish to have at up"
}