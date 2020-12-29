# Rebuild and swap WSL2 kernel (requires netem kernel module)
# TODO: provide better instructions for building custom kernel
# Look at https://gist.github.com/cerebrate/d40c89d3fa89594e1b1538b2ce9d2720

# Start 3 node cluster using Docker driver and default Kubernetes version (v1.20.x at the moment of writing)
minikube start --driver=docker --nodes=3
