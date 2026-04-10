# ☁️ AWS EKS Microservices Orchestration via GitOps

> **Project Goal:** To design, provision, and manage a production-ready, highly available cluster demonstrating a fully automated GitOps workflow.

## 📖 Overview

This repository contains the infrastructure and deployment configurations for an **11-tier microservices application** (based on the Google Online Boutique demo).

Infrastructure is provisioned entirely via **Terraform**, while application deployments and state synchronization are managed continuously by **ArgoCD**. The cluster's health and compute resources are monitored using the **kube-prometheus-stack**.

-----

<img width="1424" height="861" alt="ArgoCD" src="https://github.com/user-attachments/assets/cf21b8a7-4e38-49ab-8d7c-85ba9897cc39" />


## 🛠️ Tech Stack

| Category | Tool / Technology |
| :--- | :--- |
| **Cloud Provider** | Amazon Web Services (AWS) |
| **Infrastructure as Code** | Terraform |
| **Container Orchestration** | Kubernetes (Amazon EKS) |
| **GitOps / Continuous Delivery** | ArgoCD |
| **Monitoring & Observability** | Prometheus, Grafana (Helm) |

-----

##  Grafana Dashboard

<img width="1423" height="851" alt="Grafana" src="https://github.com/user-attachments/assets/747bd260-b011-4e0e-800d-33c8ddec13dc" />


## 🚧 Roadblocks & Lessons Learned

Building this environment presented real-world infrastructure challenges that required debugging at both the AWS networking and Kubernetes control plane levels:

### 1\. Node IP Exhaustion & `FailedScheduling`

  * **The Issue:** Initially deployed the EKS cluster with a single `t3.small` node. The core Kubernetes services (CoreDNS, aws-node, kube-proxy) initialized successfully, but application pods remained in a `Pending` state.
  * **The Cause:** AWS VPC CNI assigns secondary IP addresses from the subnet to pods based on the EC2 instance size's Elastic Network Interfaces (ENI) limits. A single `t3.small` did not have the IP capacity for the full suite of microservices and their replicas.
  * **The Fix:** Updated the Terraform state to scale the managed node group from 1 to 5 instances, executing a `terraform apply -replace` to provision a cluster capable of handling high pod density.

### 2\. Registry Resolution & `ImagePullBackOff`

  * **The Issue:** Once nodes were scaled and pods were scheduled, they failed to start, getting stuck in `ImagePullBackOff`. Kubelet logs revealed: `failed to resolve reference "docker.io/library/frontend:latest"`.
  * **The Cause:** The raw application manifests defined simplified image names (e.g., `image: frontend`), causing Kubernetes to default to Docker Hub, where it lacked authentication and pathing.
  * **The Fix:** Mapped the manifests to the correct public Google Container Registry path (`gcr.io/google-samples/microservices-demo/[service-name]:v0.10.1`). Pushed the YAML updates to GitHub, allowing ArgoCD to automatically detect the drift, terminate failing pods, and spin up healthy replacements.

-----

## 🚀 How to Deploy

### 1\. Provision Infrastructure

Clone this repository and initialize the Terraform backend:

```bash
cd terraform/
terraform init
terraform plan
terraform apply --auto-approve
```

### 2\. Update Kubeconfig

Connect your local `kubectl` to the newly provisioned EKS cluster:

```bash
aws eks update-kubeconfig --region us-east-1 --name <your-cluster-name>
```

<img width="1440" height="900" alt="Kubectl get pods" src="https://github.com/user-attachments/assets/42ad8e8c-6bce-4b79-8e2f-1d48b7ed4d59" />


### 3\. Install ArgoCD

Deploy ArgoCD into the cluster to handle the GitOps synchronization:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 4\. Deploy the Application

Apply the root ArgoCD application manifest. ArgoCD will read the manifests from this repository and deploy the 11 microservices:

```bash
kubectl apply -f argocd-app.yaml
```

### 5\. Access the Storefront

Retrieve the DNS name of the AWS Classic Load Balancer routing to the frontend service:

```bash
kubectl get service frontend -n boutique
```

<img width="1431" height="857" alt="Application" src="https://github.com/user-attachments/assets/9f365f7b-3336-41f5-aaa4-483653c5ece9" />


> **Note:** *It may take 2-3 minutes for the AWS ELB health checks to pass and DNS to propagate before the site is reachable in your browser.*
