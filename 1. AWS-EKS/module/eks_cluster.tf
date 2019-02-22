########################################################################################
									# EKS-CLUSTER #
########################################################################################

# Roles #
resource "aws_iam_role" "cluster" {
	name = "${var.cluster_name}_master_cluster"
	force_detach_policies	= true
	assume_role_policy =<<POLICY
{
	"Version":"2012-10-17",
	"Statement":[
	{
	"Effect":"Allow",
	"Principal":{
	"Service":"eks.amazonaws.com"
	},
	"Action":"sts:AssumeRole"
	}
	]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.cluster.name}"
}
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.cluster.name}"
}

# Cluster # 
resource "aws_eks_cluster" "eks" {
	name		= "${var.cluster_name}"
	role_arn    = "${aws_iam_role.cluster.arn}"
	
	vpc_config {
		security_group_ids = ["${aws_security_group.cluster.id}"]
		subnet_ids		   = ["${aws_subnet.subnet.*.id}"]
		}
	depends_on = [
		"aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy",
		"aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy",
		]
	}