#########################################################
		# NGINX KUBECTL #
#########################################################

# Path Location for the kubeconfig, must be located inside the /.kube #
# folder for kubernetes to read it #

variable "config_output_path" {
	description = "Will put the kube config file in the location of the /.kube folder for kuberenetes to find"
	default		= "C:/Users/profile/.kube/"
	}
	
# Telling terraform to create the file kubeconfig and move it to the location # 
# said in our variable #

resource "local_file" "config" {
	depends_on = [
			"aws_eks_cluster.eks",
			]

	content = "${local.kubeconfig}"
	filename = "${var.config_output_path}config"
}

# Creating aws-auth.yaml file based on our output file # 

resource "local_file" "aws-auth" {
	depends_on = [
			"aws_eks_cluster.eks",
			]
	content = "${local.config-map-aws-auth}"
	filename = "${path.root}/aws-auth.yaml"
	}
# Creating an empty resource here so that we can provision our commands #
# We are also telling it to wait till the above aws-auth is created and the cluster # 

resource "null_resource" "kubectl" {
	depends_on = [
			"local_file.aws-auth",
			"aws_eks_cluster.eks",
			]
	provisioner "local-exec" {
		command = "kubectl apply -f aws-auth.yaml"
	}
}