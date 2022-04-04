ARGO_VERSION = v3.3.1
LITMUS_VERSION = 2.7.0

ARGO_NS = argo
CHAOS_NS = chaos-framework
CHAOS_APP_NS = chaos-app

.PHONY: setup-all
setup-all: setup-litmus setup-argo setup-chaos

.PHONY: setup-litmus
setup-litmus:
	# Install Litmus operator.
	kubectl apply -f https://raw.githubusercontent.com/litmuschaos/litmus/master/mkdocs/docs/litmus-operator-v$(LITMUS_VERSION).yaml
	# Install service account for Litmus.
	kubectl apply -f https://raw.githubusercontent.com/litmuschaos/litmus/$(LITMUS_VERSION)/mkdocs/docs/litmus-admin-rbac.yaml
	# Install generic experiments.
	kubectl apply -f https://hub.litmuschaos.io/api/chaos/$(LITMUS_VERSION)?file=charts/generic/experiments.yaml -n litmus

.PHONY: setup-argo
setup-argo:
	kubectl create ns $(ARGO_NS) || echo "Namespace $(ARGO_NS) already exists."
	# Install service account and config map for Argo Workflows.
	kubectl apply -f deploy/argo.yaml -n litmus
	# Install Argo Workflows.
	kubectl apply -f https://github.com/argoproj/argo-workflows/releases/download/$(ARGO_VERSION)/install.yaml -n $(ARGO_NS)
	# Override auth method from 'sso' to 'server'.
	kubectl patch deploy/argo-server -n $(ARGO_NS) -p '{"spec": {"template": {"spec": {"containers": [{"name": "argo-server", "args": ["server", "--auth-mode", "server"]}]}}}}'
	# Override runtime executor from 'emissary' to 'k8sapi'.
	kubectl patch deploy/workflow-controller -n $(ARGO_NS) -p '{"spec": {"template": {"spec": {"containers": [{"name": "workflow-controller", "args": ["--configmap", "workflow-controller-configmap-k8sapi", "--executor-image", "quay.io/argoproj/argoexec:v3.3.1"]}]}}}}'

.PHONY: setup-chaos
setup-chaos:
	kubectl create ns $(CHAOS_NS) || echo "Namespace $(CHAOS_NS) already exists."
	kubectl create ns $(CHAOS_APP_NS) || echo "Namespace $(CHAOS_APP_NS) already exists."
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-scheduler/master/deploy/scheduler.yaml
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-workflows/master/deploy/workflows.yaml
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-frontend/master/deploy/frontend.yaml

.PHONY: setup-example-app
setup-example-app:
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/bully-election/master/deploy/bully-election.yml -n $(CHAOS_APP_NS)
	kubectl apply -f https://raw.githubusercontent.com/iskorotkov/bully-election-dashboard/master/deploy/bully-election-dashboard.yml -n bully-election-dashboard

setup-chaos-app-role:
	kubectl apply -f deploy/chaos-app-role.yaml -n $(CHAOS_APP_NS)
