provider "kubernetes" {
  config_path = pathexpand(var.kubeconfig_path)
}
resource "kubernetes_namespace_v1" "Tuckin" {
  metadata {
    name = var.namespace
    labels = { app = "Tuckin", environment = var.environment }
  }
}
output "namespace" { value = kubernetes_namespace_v1.Tuckin.metadata[0].name }
