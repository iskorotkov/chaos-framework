# Chaos Framework

Chaos Framework is a platform for easy resilience testing in Kubernetes. It automatically generates test scenario and executes it against your distributed app by simulating various failures.

- [Chaos Framework](#chaos-framework)
  - [Overview](#overview)
  - [Features](#features)
  - [Platforms](#platforms)
    - [Windows 10 WSL2 and netem](#windows-10-wsl2-and-netem)
  - [Dependencies](#dependencies)
  - [Installation](#installation)
  - [Requirements](#requirements)
  - [FAQ and troubleshooting](#faq-and-troubleshooting)
  - [Other repos](#other-repos)

## Overview

The platform generates a test scenario consisting of several stages. Stages are executed in order they are listed in a scenario. Each stage consists of several simultaneously running steps where each step represents a single failure with a single target. A stage can contain several steps that target one specific target, or it can contain several steps with the same failure targeting different targets.

## Features

Current status of development is shown here:

- failures
  - [x] container CPU hog
  - [x] container memory hog
  - [x] container network corruption
  - [x] container network duplication
  - [x] container network latency
  - [x] container network loss
  - [x] node CPU hog
  - [x] node IO stress
  - [x] node memory hog
  - [x] pod delete
  - [x] pod IO stress
  - [ ] node restart (not yet implemented)
  - [ ] disk fill (not yet implemented)
  - [ ] node crash (not yet implemented)
  - [ ] HTTP message corruption (not yet implemented, see Muxy)
  - [ ] load testing (not yet implemented, see Gatling)
  - [ ] memory corruption, RNG starvation, DNS block (not yet implemented, see Chaos Engine)
  - [ ] a lot more
- target selection
  - [x] target a random pod of a deployment
  - [x] target specific percentage of pods of a deployment
  - [x] target all pods of a deployment
  - [x] target specific node
  - [ ] target a specific pod (can't select specific pod yet)
  - [ ] target an entire cluster (no cluster-level failures implemented yet)
- test generation
  - [x] automatically generate test
  - [x] preview generated test
- test monitoring
  - [x] show test progress in a browser
- extensibility
  - [ ] set conditions before and after each stage of the test

## Platforms

The platform does not have vendor-specific functionality and theoretically can be used in any Kubernetes cluster. It was tested in the following environments:

- [x] cloud providers
  - [x] Azure Kubernetes Service
  - [x] Digital Ocean (Kubernetes v1.19.6; doesn't work on Kubernetes v1.20.2 due to errors in Argo Workflows)
- [x] Windows 10 (2004)
  - [x] minikube with VirtualBox driver
  - [x] minikube with Docker driver (WSL2) - [additional setup required](#windows-10-wsl2-and-netem)
  - [x] Kubernetes cluster in Docker Desktop (WSL2) - [additional setup required](#windows-10-wsl2-and-netem)
- [x] Linux (Ubuntu 20.04, Ubuntu 20.10, Fedora 34)
  - [x] minikube with Docker driver
  - [x] minikube with KVM driver

Note: when running on a platform where Linux kernel doesn't have netem module all network-related failures will not work! For Windows 10 WSL2 see [this section](#windows-10-wsl2-and-netem).

### Windows 10 WSL2 and netem

On Windows 10 WSL2 all network-related failures with not work due to missing netem module in the default kernel. You have to either use another way to create a Kubernetes cluster or recompile and swap the default WSL2 kernel.

See [WSL2 kernel Github repo](https://github.com/microsoft/WSL2-Linux-Kernel) and [detailed instruction on how to recompile and swap it](https://microhobby.com.br/blog/2019/09/21/compiling-your-own-linux-kernel-for-windows-wsl2/). Keep in mind that the instruction doesn't show you how to enable netem module, it only shows general process of modifying the kernel. You will have to find (use CTRL+F) substring “NETEM” in the config and change it.

## Dependencies

The platform requires you to deploy several dependencies:

- [Argo Workflows](https://argoproj.github.io/)
- [Litmus](https://litmuschaos.io/)

You can deploy them using instructions from official docs (recommended) or use [installation section](#installation) below.

## Installation

1. Make sure your Kubernetes cluster is running and `kubectl` is installed.

2. Install requirements:

    1. Install the latest stable Litmus (v1.13.2):

        ```shell
        # Install Litmus operator
        kubectl create ns litmus
        kubectl apply -f https://litmuschaos.github.io/litmus/litmus-operator-v1.13.2.yaml
        # Install generic experiments
        kubectl apply -f https://hub.litmuschaos.io/api/chaos/1.13.2?file=charts/generic/experiments.yaml -n litmus
        # Setup ServiceAccount
        kubectl apply -f https://litmuschaos.github.io/litmus/litmus-admin-rbac.yaml
        # Setup ServiceAccount for Argo
        kubectl apply -f https://raw.githubusercontent.com/litmuschaos/chaos-workflows/master/Argo/argo-access.yaml -n litmus
        ```

    2. Install the latest stable Argo (v2.12.9):

        ```shell
        kubectl create ns argo
        kubectl apply -f https://raw.githubusercontent.com/argoproj/argo/v2.12.9/manifests/install.yaml -n argo
        ```

3. Install the latest stable components of Chaos Framework:

    ```shell
    # Scheduler backend
    kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-scheduler/master/deploy/scheduler.yaml
    # Workflows backend
    kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-workflows/master/deploy/workflows.yaml
    # Frontend
    kubectl apply -f https://raw.githubusercontent.com/iskorotkov/chaos-frontend/master/deploy/frontend.yaml
    ```

4. Install sample apps (or install yours):

    ```shell
    # Create a new namespace (by default use "chaos-app" namespace)
    kubectl create ns chaos-app
    # Server
    kubectl apply -n chaos-app -f https://raw.githubusercontent.com/iskorotkov/chaos-server/master/deploy/counter.yaml
    # Client
    kubectl apply -n chaos-app -f https://raw.githubusercontent.com/iskorotkov/chaos-client/master/deploy/counter.yaml
    ```

5. Launch test workflow:

    1. Connect to Chaos Frontend:

        ```shell
        kubectl port-forward -n chaos-framework deploy/frontend 8811:80
        ```

    2. Open `http://localhost:8811/` in your browser.

    3. Tweak parameters and launch a workflow.

    4. (Optional) Connect to Argo:

        ```shell
        kubectl port-forward -n argo deploy/argo-server 2746:2746
        ```

    5. (Optional) Open `http://localhost:2746/` in your browser for a more detailed info on workflows.

## Requirements

In order for your custom applications and deployments to work, make sure they have all the following:

- Deployments and pods must contain label `app=<name>`. This label is used for selecting targets in a target namespace. Label key can be changed via environment variables (see [Scheduler's README](https://github.com/iskorotkov/chaos-scheduler)).
- Pods should contain a single container. Now it's only possible to induce failures on the first container in the pod, so all additional containers will be ignored.
- Deployments and pods must be annotated with `litmuschaos.io/chaos: "true"`. This annotation prevents Litmus from invoking more damage on your application than expected. See [Litmus docs](https://docs.litmuschaos.io/docs/getstarted/).

## FAQ and troubleshooting

Q: All failures don't work.

A: Check [requirements](#requirements). All target deployments and pods must have the matching label `app=<name>` and annotation `litmuschaos.io/chaos: "true"`.

---

Q: Network-related failures don't work.

A: Check if [netem kernel module is available](#windows-10-wsl2-and-netem).

---

Q: How to change Argo host/port/namespace (e. g. custom Argo deployment)?

Q: How to change Litmus namespace (e. g. custom Litmus deployment)?

Q: How to use another label for selecting targets?

Q: How to change a target namespace?

Q: How to change a duration, or an interval of test stages?

A: Download [Scheduler manifest](https://github.com/iskorotkov/chaos-scheduler/blob/master/deploy/scheduler.yaml), change environment variables and redeploy it. See [Scheduler's README](https://github.com/iskorotkov/chaos-scheduler) for more info.

---

Q: I try to delete a Kubernetes resource, but it won't get deleted (i. e. kubectl is stuck at deletion).

A: Edit the resource manually in your text editor and remove all finalizers. If it doesn't work (or if the resource doesn't have any finalizers) find related resources and delete finalizers in them (e.g. when CRD deletion is stuck, delete all instances of this CRD).

---

Q: Test workflow always fails after stage completion due to no reason.

A: Kubernetes v1.20+ may cause this. Downgrade your cluster to v1.19 and check if error occurs again.

## Other repos

Chaos Framework components:

- [Scheduler](https://github.com/iskorotkov/chaos-scheduler)
- [Monitor](https://github.com/iskorotkov/chaos-monitor)
- [Workflows](https://github.com/iskorotkov/chaos-workflows)
- [Frontend](https://github.com/iskorotkov/chaos-frontend)
- [Reducer (alpha)](https://github.com/iskorotkov/chaos-reducer)

Sample apps:

- [Server](https://github.com/iskorotkov/chaos-server)
- [Client](https://github.com/iskorotkov/chaos-client)
- [CPU stress](https://github.com/iskorotkov/chaos-cpu-stress)
- [IO stress](https://github.com/iskorotkov/chaos-io-stress)
- [Web Todo](https://github.com/iskorotkov/web-todo)
- [Bully election algorithm](https://github.com/iskorotkov/bully-election)
