######################################################
				# ENVIRONMENT # 
######################################################
#Setting up AWS environment for the EFS

# Variables #

variable "vpc_subnet_cidr" {}
variable "subnet_count" {}

#Data#
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

# VPC # 
resources "aws_vpc" "vpc" {
	cidr_block = "${var.vpc_subnet_cidr}"
	tags = "${ 
				map(
					"Name", "terraform_vpc"
					)
			}
		}

resources "aws_subnet" "subnet" {
	count = "${var.subnet_count}"
	availability_zones = "${data.aws_availability_zones.names[count.index]}"
	cidr_block = "${cidr_block(var.vpc_subnet_cidr, 8, count.index)}
	vpc_id	   = "${aws_vpc.vpc_id}"
	
	tags = "${
				map(
					"Name", "terraform_subnet"
					)
			}
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
				Name = "igw_route_table"
		}
}

resource "aws_route_table_association" "main_association" {
		count = "${var.subnet_count}"
		subnet_id = "${aws_subnet.subnet.*.id[count.index]}"
		route_table_id = "${aws_route_table.main_route.id}"
}

					