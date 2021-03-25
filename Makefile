.PHONY: setup-all
setup-all: setup-litmus setup-argo setup-chaos setup-app

.PHONY: setup-litmus
setup-litmus:
	# Install Litmus operator
	kubectl create ns litmus
	kubectl apply -f https://litmuschaos.github.io/litmus/litmus-operator-v1.13.0.yaml
	# Install generic experiments
	kubectl apply -f https://hub.litmuschaos.io/api/chaos/1.13.0?file=charts/generic/experiments.yaml -n litmus
	# Setup ServiceAccount
	kubectl apply -f https://litmuschaos.github.io/litmus/litmus-admin-rbac.yaml
	# Setup ServiceAccount for Argo
	kubectl apply -f https://raw.githubusercontent.com/litmuschaos/chaos-workflows/master/Argo/argo-access.yaml -n litmus

.PHONY: setup-argo
setup-argo:
	kubectl create ns argo
	kubectl apply -f https://raw.githubusercontent.com/argoproj/argo/stable/manifests/install.yaml -n argo

.PHONY: setup-chaos
setup-chaos:
	# Scheduler backend
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-scheduler/master/deploy/scheduler.yaml
	# Workflows backend
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-workflows/master/deploy/workflows.yaml
	# Frontend
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-frontend/master/deploy/frontend.yaml

.PHONY: setup-app
setup-app:
	# Create a new namespace (by default use "chaos-app" namespace)
	kubectl create ns chaos-app