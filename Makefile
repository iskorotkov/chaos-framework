ARGO_VERSION = v2.12.9
LITMUS_VERSION = v1.13.2
LITMUS_EXPERIMENTS_VERSION = 1.13.2

ARGO_NS = argo
LITMUS_NS = litmus
CHAOS_NS = chaos-app

.PHONY: setup-all
setup-all: create-ns setup-litmus setup-argo setup-chaos

.PHONY: create-ns
create-ns:
	kubectl create ns $(ARGO_NS)
	kubectl create ns $(LITMUS_NS)
	kubectl create ns $(CHAOS_NS)

.PHONY: setup-litmus
setup-litmus:
	# Install Litmus operator
	kubectl apply -f https://litmuschaos.github.io/litmus/litmus-operator-$(LITMUS_VERSION).yaml
	# Install generic experiments
	kubectl apply -f https://hub.litmuschaos.io/api/chaos/$(LITMUS_EXPERIMENTS_VERSION)?file=charts/generic/experiments.yaml -n litmus
	# Setup ServiceAccount
	kubectl apply -f https://litmuschaos.github.io/litmus/litmus-admin-rbac.yaml
	# Setup ServiceAccount for Argo
	kubectl apply -f https://raw.githubusercontent.com/litmuschaos/chaos-workflows/master/Argo/argo-access.yaml -n litmus

.PHONY: setup-argo
setup-argo:
	# Install Argo operator
	kubectl apply -f https://raw.githubusercontent.com/argoproj/argo/$(ARGO_VERSION)/manifests/install.yaml -n argo

.PHONY: setup-chaos
setup-chaos:
	# Scheduler backend
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-scheduler/master/deploy/scheduler.yaml
	# Workflows backend
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-workflows/master/deploy/workflows.yaml
	# Frontend
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-frontend/master/deploy/frontend.yaml
