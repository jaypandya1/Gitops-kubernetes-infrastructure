# 🚢 GitOps Kubernetes Fleet: Online Boutique

This repository houses the infrastructure and GitOps deployment configurations for a highly scalable, 11-tier microservices application running on Amazon EKS. 

Instead of traditional "push-based" CI/CD pipelines, this project utilizes a **Pull-based GitOps architecture** via **ArgoCD**. The cluster continuously monitors this repository as the "Single Source of Truth." If the live cluster deviates from the YAML manifests stored here, ArgoCD automatically reconciles the drift, ensuring a self-healing environment.

### 🏗️ Architecture & Tech Stack
* **Compute:** AWS Elastic Kubernetes Service (EKS) provisioned via **Terraform**.
* **Workload:** 11 distinct microservices (Go, Python, Node.js, Java) communicating via **gRPC**.
* **GitOps Controller:** **ArgoCD** managing continuous deployment and drift reconciliation.
* **Observability:** **Prometheus & Grafana** stack for scraping metric data and visualizing pod health.