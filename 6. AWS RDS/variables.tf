###########################################################
# Variables #
###########################################################

variable "cluster_identifier" {
		default = "practise"
		type = "string"
		description = "Name of the cluster"
}

variable "region" {
	default = "eu-west-1"
	type = "string"
	description = "The aws region you wish to be working on"
}

variable "master_user" {
		default	= "admin"
		type = "string"
		description = "The master username for the database"
}

variable "master_password" {
		default = "password"
		type = "string"
		description = "The password used to login into the database"
}

variable "database_name" {
		default = "practise_db"
		type    = "string"
		description = "The name of the database inside the cluster"
}

variable "instance_class" {
		default = "db.t2.small"
		type	= "string"
		description = "The instance class check AWS for more information on the CPU and memory"
}


