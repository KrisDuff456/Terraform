############################################
# VARIABLES #
############################################

variable "aws_region" {
	default = "eu-west-1"
	type 	= "string"
	description = "The AWS region to deploy the EKS is going to be in Ireland"
	}
	
variable "vpc_subnet_cidr" {
	default = "10.0.0.0/16"
	type = "string"
	description = "The vpc subnet CIDR block used for the VPC"
	}

variable "subnet_count" {
	default = "2"
	type = "string"
	description = "Number of public subnets in use"
}