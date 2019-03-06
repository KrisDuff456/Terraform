#################################################################
							# BACKEND #
##################################################################
# Here we Store the tfstate in the S3 bucket and 
# locking infromation for the DynamoDB

# First store the state then uncomment '#' to enable locking

terraform { 
	backend "s3" {
		encrypt = true 
	bucket = "terraform_state_storage"
	region = "eu-west-1"
	key = "terraform.tfstate"
	
	# dynamodb_table = "terraform_state_lock_dynamodb"
	}
}