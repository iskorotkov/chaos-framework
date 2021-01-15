#!/bin/bash
# Deploy operator
kubectl apply -f https://download.elastic.co/downloads/eck/1.3.1/all-in-one.yaml

# Create components
kubectl apply -f elasticsearch.yaml
kubectl apply -f kibana.yaml

# Retrieve password for user 'elastic'
kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 -d

