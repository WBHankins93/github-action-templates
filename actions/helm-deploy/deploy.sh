#!/bin/bash
set -euo pipefail

# Ensure the namespace argument is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NAMESPACE=$1

# Step 1: Ensure namespace exists or create it
echo "Ensuring namespace '$NAMESPACE' exists..."
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

# Step 2: Helm chart deployment (update with your Helm chart path and values)
echo "Deploying Helm chart to namespace '$NAMESPACE'..."
helm upgrade --install my-app ./helm-chart-path \
  --namespace $NAMESPACE \
  --set image.tag=latest \
  --wait

echo "Helm deployment completed successfully in namespace '$NAMESPACE'."
