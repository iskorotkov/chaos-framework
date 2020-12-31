# Create cluster
& "$PSScriptRoot\minikube\minikube-v1.16.x-windows-docker.ps1"

# Install dependencies
& "$PSScriptRoot\litmus\setup.ps1"
& "$PSScriptRoot\argo\setup.ps1"
