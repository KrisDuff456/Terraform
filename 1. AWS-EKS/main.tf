########################################
# MAIN #
########################################

provider "aws" {
	region = "${var.aws_region}"
}

########################################
# MODULES #
########################################

module "eks_cluster" {
		source = "./module"
		cluster_name = "${var.cluster_name}"
		worker_node_name = "${var.worker_name}"
		worker_instance_type = "${var.worker_instance_type}"
		desired_capacity	 = "${var.desired_capacity}"
		max_count			= "${var.max_count}"
		min_count			= "${var.min_count}"
		vpc_subnet_cidr    = "${var.vpc_subnet_cidr}"
		subnet_count	= "${var.subnet_count}"
}