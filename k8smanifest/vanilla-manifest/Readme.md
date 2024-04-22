# Nginx Application in Kubernetes

This deployment includes the following components:
- A Deployment resource for Nginx.
- A Service with a ClusterIP type.

The application can be accessed locally using port forwarding.

## Prerequisites
- A running Kubernetes cluster.
- `kubectl` command-line tool installed and configured to interact with the cluster.

## Installation
Follow these steps to install the Nginx application:

1. Create a namespace for the application:
   ```bash
   kubectl create namespace nginx
   ```
2. Apply the deployment and service configurations:
    ```bash
    kubectl apply -f deployment.yaml -n nginx
    ```
3. To access the application, use the following command to set up port forwarding, then open a browser to navigate to `http://localhost:8080`:
    ```bash
    kubectl port-forward svc/nginx-service 8080:80 -n nginx
    ```