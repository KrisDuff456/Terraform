###############################################################
						# S3 BUCKET #
###############################################################

provider "aws" {
	region = "var.region"
}

#state file setup
#create an S3 bucket to store your state file in AWS

resource "aws_s3_bucket" "terraform_s3_state_storage" {
	bucket = "terraform_state_storage" # Name of your bucket
	versioning {
		enable = true
		}
	lifecycle {
		prevent_destroy = false
	}
	
	tags { 
		Name = "S3 Remote storage"
		environment = "practise"
		project = "GitHub_terraform"
		}
	}
	
# DynamoDB table to lock the state file 

resources "aws_dynamodb_table" "terraform_dynamodb_state_lock" {
	name = "terraform_state_lock_dynamodb"
	hash_key = "ID_HERE"
	read_capacity = 30
	write_capacity = 30
	
	attribute { 
		name = "Id_here"
		type = "S"
		}
	tags {
		name = "terraform_state_lock_dynamodb"
		project = "GitHub_terraform"
		environment = "practise"
	}
}
