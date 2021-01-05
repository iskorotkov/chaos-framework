#!/bin/bash

# Create cluster
./minikube/minikube-v1.15.x-linux.sh

# Install dependecies
./litmus/setup.sh
./argo/setup.sh

# Install infrastructure
kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-scheduler/master/deploy/scheduler.yaml
kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-frontend/master/deploy/frontend.yaml
