##############################################################################
								# SECURITY GROUPS #
##############################################################################
# AWS security group configurations for the VPC, workers and cluster
resource "aws_security_group" "workers" {
	name		= "${var.worker_node_name}_sg"
	description = "Security group for all nodes in the cluster"
	vpc_id      = "${aws_vpc.vpc.id}"
	
	tags = "${
	    map(
			"Name", "${var.worker_node_name}_sg",
			"kubernetes.io/cluster/${var.cluster_name}", "owned",
		)
	}"
	egress { 
		from_port   = 0 
		to_port     = 0 
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		}
	}
	
resource "aws_security_group" "cluster" {
	name 	    = "${var.cluster_name}_sg"
	description = "Cluster communication with worker nodes"
    vpc_id	    = "${aws_vpc.vpc.id}"
	
	tags {
		Name = "${var.cluster_name}_sg"
		}
	}

# Security Group for the port 22 #
resource "aws_security_group_rule" "bastion-ingress-rule" {
	description = "allow the worker nodes to be accessed via the bastion server"
	protocol = "tcp"
	from_port   = 22
	to_port     = 22
	security_group_id = "${aws_security_group.workers.id}"
	type = "ingress"
}
	
# Security Groups for the ports 443 #

resource "aws_security_group_rule" "node-ingress-cluster-https" {
  description              = "Allow pods to communicate with port 443 to receive communication from cluster"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.workers.id}"
  source_security_group_id = "${aws_security_group.cluster.id}"
  to_port                  = 443
  type                     = "ingress"
}
resource "aws_security_group_rule" "cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster.id}"
  source_security_group_id = "${aws_security_group.workers.id}"
  to_port                  = 443
  type                     = "ingress"
}
resource "aws_security_group_rule" "cluster-egress-node-https" {
  description              = "Allow the cluster control plane to communicate with pods running extension API servers"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster.id}"
  source_security_group_id = "${aws_security_group.workers.id}"
  to_port                  = 443
  type                     = "egress"
}

# Security Groups from port 65535 #

resource "aws_security_group_rule" "workers-ingress-self" {
	description				= "Allow node to communicate with each other"
	from_port				= 0 
	protocol				= "-1"
	security_group_id		= "${aws_security_group.workers.id}"
	source_security_group_id = "${aws_security_group.workers.id}"
	to_port					= 65535
	type					= "ingress"
}

resource "aws_security_group_rule" "workers-ingress-cluster" {
	description					= "Allow worker nodes and pods to receive communication from the cluster control plane"
	from_port					= 1025
	protocol					= "tcp"
	security_group_id			= "${aws_security_group.workers.id}"
	source_security_group_id    = "${aws_security_group.cluster.id}"
	to_port						= 65535
	type						= "ingress"
	}
	
resource "aws_security_group_rule" "workers-egress-cluster" {
	description					= "Allow cluster to communicate with workers and pods"
	from_port					= 1025
	protocol					= "tcp"
	security_group_id			= "${aws_security_group.cluster.id}"
	source_security_group_id    = "${aws_security_group.workers.id}"
	to_port						= 65535
	type						= "egress"
	}
