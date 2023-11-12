resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
  depends_on = [aws_eks_cluster.dev_web_eks_cluster]
}

resource "kubernetes_manifest" "dev_web_deployment_block" {
  depends_on = [kubernetes_namespace.dev]
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "dev-web-deployment"
      namespace = "dev"
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = "web-nginx-app"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "web-nginx-app"
          }
        }
        spec = {
          containers = [
            {
              name  = "web-nginx-app-container"
              image = "nginx:latest"
              ports = [
                {
                  containerPort = 80
                }
              ]
            }
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "dev_web_LB_block" {
  depends_on = [kubernetes_namespace.dev]
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "dev-web-lb"
      namespace = "dev"
    }
    spec = {
      type = "LoadBalancer"
      selector = {
        app = "web-nginx-app"
      }
      ports = [
        {
          protocol   = "TCP"
          port       = 80
          targetPort = 80
        }
      ]
    }
  }
}
