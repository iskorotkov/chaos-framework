# Start 1 node cluster using VirtualBox driver and default Kubernetes version (v1.20.x at the moment of writing)
# Note: skip VT-X check that prevents cluster from starting
minikube start --driver=virtualbox --no-vtx-check --nodes=1
