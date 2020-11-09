#!/bin/bash
# Visualize in Chaos Dashboard
kubectl port-forward svc/chaos-dashboard 2333 -n chaos-mesh
