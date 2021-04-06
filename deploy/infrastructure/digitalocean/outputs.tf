output "cluster_name" {
  value       = digitalocean_kubernetes_cluster.chaos_framework.name
  description = "Name of the created cluster"
}

output "save_cluster_config_cmd" {
  value = "doctl kubernetes cluster kubeconfig save ${digitalocean_kubernetes_cluster.chaos_framework.name}"
  description = "Execute this command to add kubeconfig of the created cluster to your local config"
}
