#!/bin/bash

# Install InfluxDB
kubectl apply -f https://raw.githubusercontent.com/influxdata/docs-v2/master/static/downloads/influxdb-k8-minikube.yaml

# Create secret with InfluxDB token
kubectl create ns influxdb-telegraf
kubectl create secret generic telegraf-secret -n influxdb-telegraf --from-literal=token=$TOKEN

# Install Telegraf
kubectl apply -f telegraf.yaml
