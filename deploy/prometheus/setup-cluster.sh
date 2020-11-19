#!/bin/bash

# Delete existing cluster
minikube delete

# Create new cluster
minikube start --kubernetes-version=v1.19.4 --memory=6g --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.address=0.0.0.0 --extra-config=controller-manager.address=0.0.0.0
