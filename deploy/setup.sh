#!/bin/bash
# Install Argo
kubectl create ns argo
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo/stable/manifests/install.yaml -n argo

# Install Litmus
kubectl create ns litmus
kubectl apply -f https://litmuschaos.github.io/litmus/litmus-operator-v1.9.0.yaml

# Install generic experiments
kubectl apply -f https://hub.litmuschaos.io/api/chaos/1.9.1?file=charts/generic/experiments.yaml -n litmus

# Setup ServiceAccount
kubectl apply -f https://litmuschaos.github.io/litmus/litmus-admin-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/litmuschaos/chaos-workflows/master/Argo/argo-access.yaml -n litmus

# Visualize chaos workflow
kubectl port-forward svc/argo-server 2746 -n argo
