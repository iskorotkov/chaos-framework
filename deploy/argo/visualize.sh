#!/bin/bash
# Visualize Argo workflow
kubectl port-forward svc/argo-server 2746 -n argo
