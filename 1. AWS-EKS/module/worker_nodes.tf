#########################################################################
							# WORKER NODES #
#########################################################################

# Variables #
variable "worker_instance_type" {}
variable "worker_node_name" {}
variable "max_count" {}
variable "min_count" {}
variable "desired_capacity" {}

# Worker Role & Policy # 
resource "aws_iam_role" "workers" {
	name    = "${var.cluster_name}_worker_role"
	force_detach_policies 		= true
	assume_role_policy   = <<POLICY
{	
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Principal": {"Service": "ec2.amazonaws.com"},
		"Action": "sts:AssumeRole"}]
}
POLICY
}

# Policy Attachment # 
resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.workers.name}"
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.workers.name}"
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.workers.name}"
}

# Worker Node Instances #
resource "aws_iam_instance_profile" "workers" {
  name = "${var.worker_node_name}"
  role = "${aws_iam_role.workers.name}"
}

# Data #
# Using data resource to search for the optimized AMI 
# Using a filter by name and looking for the most recent AMI in AWS
data "aws_ami" "eks-worker-ami" {
	filter {
	name   = "name"
	values = ["amazon-eks-node-v*"]
           }

	most_recent = true
	owners		= ["602401143452"] # Amazon EKS AMI Account ID 
	}

# Currently required by EKS for the worker nodes to configure with the 
# kubernetes application in the EC2 instances.	
locals {
workers-userdata = <<USERDATA
#!/usr/bin/env bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

# AutoScaling Configurations #
# Auto Scaling launch configurations, using our defined resources we 
# can create the EC2 instance.
resource "aws_launch_configuration" "workers" {
	associate_public_ip_address		= true
	iam_instance_profile 			= "${aws_iam_instance_profile.workers.name}"
	image_id						= "${data.aws_ami.eks-worker-ami.id}"
	instance_type					= "${var.worker_instance_type}"
	name_prefix						= "${var.cluster_name}"
	security_groups					= ["${aws_security_group.workers.id}"]
	user_data_base64				= "${base64encode(local.workers-userdata)}"
	
	lifecycle {
		create_before_destroy = true
		}
	}
# AutoScaling Group that uses the launch configuration to acctually create the instance.
resource "aws_autoscaling_group" "workers" {
	desired_capacity			= "${var.desired_capacity}"
	launch_configuration		= "${aws_launch_configuration.workers.id}"
	max_size					= "${var.max_count}"
	min_size					= "${var.min_count}"
	health_check_grace_period 	= 0
	health_check_type         	= "EC2"
	wait_for_capacity_timeout   = 0
	force_delete				= true
	name						= "${var.cluster_name}_asg"
	vpc_zone_identifier			= ["${aws_subnet.subnet.*.id}"]
	
	tag {
		key				= "Name"
		value			= "${var.worker_node_name}"
		propagate_at_launch = true
		}
	tag { 
		key				= "kubernetes.io/cluster/${var.cluster_name}"
		value     		= "owned"
		propagate_at_launch = true
		}
}