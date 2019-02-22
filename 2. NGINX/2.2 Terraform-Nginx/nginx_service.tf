##########################################################
				# NGINX Service creation #
##########################################################

# Service #
resource "kubernetes_service" "nginx_service" {
	metadata {
		name	= "nginx-service"
	}
	spec {
		selector {
			app = "${kubernetes_pod.nginx_pod.metadata.0.labels.app}"
			}
		port {
		name  = "https"
		 port = 443
		 target_port = 443
		 }
		port {
		name  = "http"
		 port = 80
		 target_port = 80
		 }
		 type = "LoadBalancer"
	}
}

resource "kubernetes_pod" "nginx_pod" {
  metadata {
    name = "nginx-pod"
    labels {
      app = "nginx-pod"
    }
  }

  spec {
    container {
      image = "nginx:1.15.6"
      name  = "nginx"
    
	port {
	container_port = 80
	container_port = 443
	}
   }
  }
}