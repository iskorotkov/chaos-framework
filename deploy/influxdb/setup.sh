#!/bin/bash

# Install InfluxDB configuration
kubectl apply -f https://raw.githubusercontent.com/influxdata/docs-v2/master/static/downloads/influxdb-k8-minikube.yaml

# Add repo
# helm repo add influxdata https://helm.influxdata.com/
# helm repo update

# Create namespace
kubectl create ns influxdb-telegraf

# Create secret
kubectl create secret -n influxdb-telegraf generic telegraf

# Launch Telegraf DaemonSet
kubectl apply -f telegraf.yaml

# Install or upgrade release (https://github.com/influxdata/helm-charts/tree/master/charts/telegraf-ds)
# helm upgrade --install telegraf -n influxdb-telegraf influxdata/telegraf-ds

# [optional] Or install with config file
# helm upgrade --install telegraf -n influxdb-telegraf -f telegraf.conf influxdata/telegraf-ds

# [optional] If upgrade --install doesn't work
# helm install telegraf-ds -n influxdb-telegraf influxdata/telegraf-ds

# [optional] Connect to pod via ssh
# kubectl exec pod/{pod-name} -n influxdb-telegraf -it -- /bin/sh

# [optional] Set INFLUX_TOKEN
# export INFLUX_TOKEN=KG3broQRK60Z0o2WF04-CK9rLjWJ7YIkLtqnwt-F3PzGtZ_fw_nBqGYqpQwpJ1KY2BLQlgt7XTV39ckGJCcCcg==

# [optional] Connect to API Server
# TODO:

# [optional] Retrieve Telegraf config
# telegraf --config http://127.0.0.1:8086/api/v2/telegrafs/06a14ce71041f000
