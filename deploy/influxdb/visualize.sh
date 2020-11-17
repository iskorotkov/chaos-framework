#!/bin/bash

# GUI
kubectl port-forward -n influxdb service/influxdb 8086:8086
