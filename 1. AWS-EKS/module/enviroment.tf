########################################################################
							# ENVIRONMENT # 
########################################################################
# Setting up AWS environment for our cluster
# and nodes

# Variables #
# Referencing out variables  

variable "cluster_name" {}
variable "vpc_subnet_cidr" {}
variable "subnet_count" {}
 
# Data #
# Use 'data' to set up a search parameter for terraform to use.
# Here we are doign a search within in the region and the availability zones within 
# each subnet. 
  
data "aws_region" "current" {}
data "aws_availability_zones" "available"{}

# VPC #
resource "aws_vpc" "vpc" {
	cidr_block = "${var.vpc_subnet_cidr}"
	enable_dns_support = "true"
	enable_dns_hostnames = "true"
	
	tags = "${
				map(
					"Name", "$(var.cluster_name)_vpc",
					"kubernetes.io/cluster/${var.cluster_name}", "shared",
				   )
			}"
}

# Subnet #
# Creating a public subnet here if you wished to create a private subnets as well
# You will need to set up a NAT Gateway with at least one public subnet. 
resource "aws_subnet" "subnet" {	
	count   = "${var.subnet_count}"
	availability_zone	= "${data.aws_availability_zones.available.names[count.index]}"
	cidr_block			= "${cidrsubnet(var.vpc_subnet_cidr, 8, count.index)}"
	vpc_id				= "${aws_vpc.vpc.id}"
	
	tags = "${
		map(
			"Name", "${var.cluster_name}_subnet",
			"kubernetes.io/cluster/${var.cluster_name}", "shared",
			)
		}"
	}
	
# Internet Gateway #
resource "aws_internet_gateway" "igw" {
	vpc_id = "${aws_vpc.vpc.id}"
	
	tags { 
			Name = "${var.cluster_name}_igw"
		 }
}

# Route Table #
resource "aws_route_table" "main_route" {
		vpc_id = "${aws_vpc.vpc.id}"
		route { 
				cidr_block	= "0.0.0.0/0"
				gateway_id	= "${aws_internet_gateway.igw.id}"
			  }
		
		tags { 
				Name = "${var.cluster_name}_igw_route_table"
		}
}

resource "aws_route_table_association" "main_association" {
		count = "${var.subnet_count}"
		subnet_id = "${aws_subnet.subnet.*.id[count.index]}"
		route_table_id = "${aws_route_table.main_route.id}"
}