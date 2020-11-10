#!/bin/bash
# Add Chaos Mesh repository to Helm repos
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm update

# Create custom resource type
curl -sSL https://mirrors.chaos-mesh.org/v1.0.2/crd.yaml | kubectl apply -f -

# Install Chaos Mesh
kubectl create ns chaos-mesh
helm install chaos-mesh chaos-mesh/chaos-mesh --namespace=chaos-mesh --set dashboard.create=true
