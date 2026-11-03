provider "kubernetes" {
  config_path = pathexpand(var.kubeconfig_path)
}
resource "kubernetes_namespace_v1" "mealtrail" {
  metadata {
    name = var.namespace
    labels = { app = "mealtrail", environment = var.environment }
  }
}
output "namespace" { value = kubernetes_namespace_v1.mealtrail.metadata[0].name }
