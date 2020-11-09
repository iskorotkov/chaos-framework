#!/bin/bash
kubectl create ns chaos-app
kubectl apply -f chaos-app.yaml -n chaos-app
