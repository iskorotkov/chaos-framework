ARGO_VERSION = v3.2.4
LITMUS_VERSION = 2.3.0

ARGO_NS = argo
LITMUS_NS = litmus
CHAOS_NS = chaos-framework
CHAOS_APP_NS = chaos-app

.PHONY: setup-all
setup-all: create-ns setup-litmus setup-argo setup-chaos

.PHONY: create-ns
create-ns:
	kubectl create ns $(LITMUS_NS)
	kubectl create ns $(ARGO_NS)
	kubectl create ns $(CHAOS_NS)
	kubectl create ns $(CHAOS_APP_NS)

.PHONY: setup-litmus
setup-litmus:
	kubectl apply -f https://litmuschaos.github.io/litmus/$(LITMUS_VERSION)/litmus-$(LITMUS_VERSION).yaml -n $(LITMUS_NS)
	kubectl apply -f https://raw.githubusercontent.com/litmuschaos/chaos-operator/$(LITMUS_VERSION)/deploy/chaos_crds.yaml
	kubectl apply -f https://hub.litmuschaos.io/api/chaos/$(LITMUS_VERSION)?file=charts/generic/experiments.yaml -n $(LITMUS_NS)
	kubectl apply -f https://raw.githubusercontent.com/litmuschaos/chaos-workflows/master/Argo/argo-access.yaml -n $(LITMUS_NS)

.PHONY: setup-argo
setup-argo:
	# kubectl apply -f https://github.com/argoproj/argo-workflows/releases/download/$(ARGO_VERSION)/install.yaml  -n $(ARGO_NS)
	# We override auth method to from 'sso' to 'server' and set non-default executor to 'k8sapi', so we have to use local file.
	kubectl apply -f deploy/argo.yaml -n $(ARGO_NS)

.PHONY: setup-chaos
setup-chaos:
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-scheduler/master/deploy/scheduler.yaml
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-workflows/master/deploy/workflows.yaml
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-frontend/master/deploy/frontend.yaml

.PHONY: setup-example-app
setup-example-app:
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/bully-election/master/deploy/bully-election.yml -n $(CHAOS_APP_NS)
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/bully-election-dashboard/master/deploy/bully-election-dashboard.yml -n bully-election-dashboard

