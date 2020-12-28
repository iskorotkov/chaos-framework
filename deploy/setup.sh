#!/bin/bash

# Create cluster
./minikube/minikube-v1.15.x-linux.sh

# Install dependecies
./litmus/setup.sh
./argo/setup.sh

# Install sample app
./sample-app/setup.sh
