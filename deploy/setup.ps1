# Create cluster
& "$PSScriptRoot\minikube\minikube-v1.16.x-windows-docker.ps1"

# Install dependencies
& "$PSScriptRoot\litmus\setup.ps1"
& "$PSScriptRoot\argo\setup.ps1"

# Install infrastructure
kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-scheduler/master/deploy/scheduler.yaml
kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-frontend/master/deploy/frontend.yaml
