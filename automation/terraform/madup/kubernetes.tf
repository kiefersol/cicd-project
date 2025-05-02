provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 3
            period_seconds        = 5
          }
        }
      }
    }
  }
}

# PodDisruptionBudget - 노드 종료나 업그레이드 같은 상황에서 Pod의 수를 최소화하여, 서비스 중단을 예방
resource "kubernetes_pod_disruption_budget" "nginx_pdb" {
  metadata {
    name      = "nginx-pdb"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }

  spec {
    min_available = 2  # 최소 2개의 Pod는 항상 가용하게 유지
    selector {
      match_labels = {
        app = "nginx"
      }
    }
  }
}

# Horizontal Pod Autoscaler - 워크로드의 부하가 증가하거나 감소할 때, Pod의 수를 자동으로 조정하여 애플리케이션의 성능을 최적화
resource "kubernetes_horizontal_pod_autoscaler" "nginx_hpa" {
  metadata {
    name      = "nginx-hpa"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name
    }

    min_replicas = 2
    max_replicas = 5

    metric {
      type = "Resource"
      resource {
        name   = "cpu"
        target {
          type          = "Utilization"
          average_utilization = 80
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }

    type = "NodePort"

    port {
      port        = 80
      target_port = 80
      node_port   = var.nginx_target_group_port
    }
  }
}

# nginx ingress controller를 사용할 때 배포하는 ingress.yaml
# resource "kubernetes_ingress_v1" "nginx" {
#   metadata {
#     name      = "nginx-ingress"
#     namespace = kubernetes_namespace.nginx.metadata[0].name
#     annotations = {
#       "nginx.ingress.kubernetes.io/whitelist-source-range" = "123.123.123.123/32"
#     }
#   }

#   spec {
#     ingress_class_name = "nginx"

#     rule {
#       host = "nginx.example.com"

#       http {
#         path {
#           path     = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = kubernetes_service.nginx.metadata[0].name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }