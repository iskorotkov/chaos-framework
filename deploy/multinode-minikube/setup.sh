#!/bin/bash

# Start 3 node cluster with Calico CNI
minikube start --kubernetes-version=v1.19.4 --nodes=3 --network-plugin=cni --cni=calico
