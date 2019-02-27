###################################################
# EFS #
###################################################

# Variable #
variable "subnet_count" {}

# EFS & Mount Target #

resource "aws_efs_file_system" "file_system" {
	creation_token = "terraform_efs_file_system"
	tags{
			Name = "terraform_efs_system"
		}
	}
	
resource "aws_efs_mount_target" "mount_id" {
	file_system_id = "${aws_efs_file_system.file_system}"
	subnet_id	= "${aws_subnet.subnet"}"
	}