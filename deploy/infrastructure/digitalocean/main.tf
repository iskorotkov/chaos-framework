terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "chaos_framework" {
  name         = "chaos-framework"
  version      = "1.20.2-do.0"
  region       = "fra1"
  auto_upgrade = false
  tags         = ["chaos-framework"]

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    auto_scale = false
    node_count = 2
  }
}
