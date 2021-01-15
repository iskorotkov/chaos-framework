#!/bin/bash
echo "Open 'https://localhost:5601' in your browser"
kubectl port-forward service/quickstart-kb-http 5601
