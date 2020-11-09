#!/bin/bash
# Add Chaos Mesh repository to Helm repos
helm repo add chaos-mesh https://charts.chaos-mesh.org

# Create custom resource type
curl -sSL https://mirrors.chaos-mesh.org/v1.0.2/crd.yaml | kubectl apply -f -

# Install Chaos Mesh
helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos-mesh --set chaosDaemon.runtime=containerd --set chaosDaemon.socketPath=/run/containerd/containerd.sock --set dashboard.create=true
