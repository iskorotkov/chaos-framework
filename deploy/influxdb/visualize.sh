#!/bin/bash

kubectl port-forward -n influxdb service/influxdb 8086:8086
