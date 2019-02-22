########################################################
	# ELASTIC CONTAINER REGISTRY #
########################################################

# ECR creation #

resource "aws_ecr_repository" "ecr_repo" {
	name = "terraform_ecr"
}

# ECR repository policy creation 
resource "aws_ecr_repository_policy" "ecr_policy" {
	repository = "${aws_ecr_repository.ecr_repo.name}"
	
	policy = <<EOF
	{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAll",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:*"
            ]
        }
    ]
}
EOF
}
