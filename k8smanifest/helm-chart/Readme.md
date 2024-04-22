# Nginx Helm Chart

This Helm chart installs the Nginx application in a Kubernetes cluster. It provides a flexible setup with the following components:
- A Deployment resource.
- A Service to expose the application within the cluster.
- An optional Ingress for external access.

## Prerequisites
- A running Kubernetes cluster.
- Helm CLI installed and configured to interact with the cluster.

## Installation
To install this Helm chart, run the following command:

    ```bash
    kubectl create ns <namespace>
    helm install nginx-release </path/to/helm-chart> -n <namespace>
    ```
## Customizing the Chart

- **Replicas**: The number of replicas for the Deployment. Default is 1.
- **Image**: The Nginx Docker image to use. Default is nginx:latest.
- **Service** Type: The type of Kubernetes Service. Default is ClusterIP.
- **Ingress**: Whether to enable Ingress. Default is false. When enabled, specify the host and path for the Ingress rule.
