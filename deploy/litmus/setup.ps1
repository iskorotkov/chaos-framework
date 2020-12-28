# Install Litmus
kubectl create ns litmus
kubectl apply -f https://litmuschaos.github.io/litmus/litmus-operator-v1.9.1.yaml

# Install generic experiments
kubectl apply -f https://hub.litmuschaos.io/api/chaos/1.9.1?file=charts/generic/experiments.yaml -n litmus

# Setup ServiceAccount
kubectl apply -f https://litmuschaos.github.io/litmus/litmus-admin-rbac.yaml

# Setup ServiceAccount for Argo
kubectl apply -f https://raw.githubusercontent.com/litmuschaos/chaos-workflows/master/Argo/argo-access.yaml -n litmus
