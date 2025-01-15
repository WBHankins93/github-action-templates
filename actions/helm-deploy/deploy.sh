# actions/helm-deploy/deploy.sh
#!/bin/bash
set -e

NAMESPACE=$1

echo "Deploying to namespace: $NAMESPACE"
helm upgrade --install my-app ./helm-chart --namespace "$NAMESPACE"
