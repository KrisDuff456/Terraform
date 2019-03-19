##############################################
			# Provider # 
##############################################

provider "aws" {
	region = "${var.aws_region}"
	description = "Using AWS cli you can store your credentitals away from your scripts so that they remain hidden"
}

##############################################
			# Data	#
##############################################

data "aws_region" "current" {}
data"aws_availability_zones" "avilable" {}

##############################################
			# Amazon Aurora # 
##############################################

resource "aws_rds_cluster" "aurora_cluster"{
	cluster_identifier			= "${var.cluster_identifier}_aurora_db_cluster"
	engine						= "aurora"
	availability_zones			= "${data.aws_availability_zones.available.names[count.index]}"
	
	database_name				= "${var.database_name}"
	master_username				= "${var.master_username}"
	master_password				= "${var.master_password}"
	
	backup_retention_period		= "0"
	preferred_backup_window		= "04:00-09:00"
	db_subnet_group_name		= ""
	
	final_snapshot_identifier	= "{var.cluster_identifier}_aurora_db_cluster"
	vpc_security_group_ids		= [ "${aws_security_group.aurora_sg.id}"]
	
	tags {
			Name			= "${var.cluster_identifier}_aurora_db_cluster"
			ManageBy		= "terrafom"
			Environment		= "${var.cluster_identifier}"
		}
}

resource "aws_rds_cluster_instance" "cluster_instance" {
	count			= 1
	identifier		= "aurora_db_cluster_${count.index}"
	cluster_identifier = "${aws_rds_cluster.aurora_cluster.id}"
	instance_class		= "${var.instance_class}"
	publicly_accessible = "false"
	
	tags {
			Name			= "${var.cluster_identifier}_aurora_db_cluster"
			ManageBy		= "terrafom"
			Environment		= "${var.cluster_identifier}"
		}
}

resource "aws_security_group" "aurora_sg"{
	names = "aurora_cluster_sg"
	description = "communication between the aurora cluster and clients"
	vpc_id		= "${local.vpc_id}"
	
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
		from_port   = 3306
		to_port     = 3306
		protocol    = "-1"
		cidr_blocks = ["${var.vpc_cidr}"]
  }
}