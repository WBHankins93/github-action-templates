# GitHub Actions Templates Repository

## Overview
This repository contains reusable GitHub Actions workflows and composite actions for CI/CD pipelines and Kubernetes deployments. It also includes an example implementation to demonstrate how to use these actions.

---

## Directory Structure

```
github-actions-templates/
  README.md
  actions/
    helm-deploy/
      action.yml
      deploy.sh
  workflows/
    ci-cd.yaml
    build-docker.yaml
  secrets/
    README.md
  .github/
    workflows/
      example-helm-deploy.yml
```

### Breakdown:
- **`actions/helm-deploy/`**: A reusable composite action for deploying Helm charts.
- **`workflows/`**: Reusable GitHub Actions workflows for CI/CD and Docker builds.
- **`.github/workflows/`**: Example workflows to test and demonstrate how to use the reusable actions.

---

## Reusable Components

### 1. `helm-deploy` Composite Action
**Location**: `actions/helm-deploy/`

This action enables Helm chart deployment to Kubernetes clusters.

#### **Files**:

**`action.yml`**
```yaml
name: "Deploy with Helm"
description: "Deploy Helm charts to Kubernetes clusters"
inputs:
  namespace:
    description: "Kubernetes namespace for deployment"
    required: true
runs:
  using: "composite"
  steps:
    - name: Deploy Chart
      run: ./deploy.sh ${{ inputs.namespace }}
```

**`deploy.sh`**
```bash
#!/bin/bash
set -e

NAMESPACE=$1

echo "Deploying to namespace: $NAMESPACE"
helm upgrade --install my-app ./helm-chart --namespace "$NAMESPACE"
```

---

### 2. Reusable Workflows

#### **CI/CD Workflow**
**Location**: `workflows/ci-cd.yaml`

A reusable CI/CD pipeline for building and deploying applications.

```yaml
name: Reusable CI/CD Workflow

on:
  workflow_call:
    inputs:
      branch:
        required: true
        type: string
      kubernetes_namespace:
        required: true
        type: string

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Install Dependencies
        run: npm install

      - name: Run Tests
        run: npm test

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Kubernetes
        uses: ./actions/helm-deploy
        with:
          namespace: ${{ inputs.kubernetes_namespace }}
```

---

## Example Usage

### Example Workflow

An example workflow (`.github/workflows/example-helm-deploy.yml`) demonstrates how to use the `helm-deploy` action.

**File**: `.github/workflows/example-helm-deploy.yml`

```yaml
name: Example Helm Deploy Workflow

on:
  push:
    branches:
      - main

jobs:
  example-helm-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Deploy using Helm
        uses: ./actions/helm-deploy
        with:
          namespace: "example-namespace"
```

---

## How to Use in Another Repository

### Step 1: Reference the Action Repository
Add a workflow in your project repository and reference this repository to use the reusable action. For example:

```yaml
name: Deploy Application

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Deploy to Kubernetes
        uses: your-org/github-actions-templates/actions/helm-deploy@v1.0.0
        with:
          namespace: "production"
```


## Secrets Directory

### Location
**Directory**: `secrets/`

This directory serves as a placeholder for instructions on acquiring necessary secrets, such as `KUBECONFIG`, for use in workflows.

### Example: `secrets/README.md`
```markdown
# Secrets Directory

## Overview
This directory contains instructions on how to acquire and configure the necessary secrets for workflows.

### Required Secrets
1. **`KUBECONFIG`**:
   - This is the Kubernetes configuration file required to authenticate with your cluster.

### Steps to Acquire Secrets
1. **Access IBM Cloud Console**:
   - Log in to the IBM Cloud Console and navigate to your Kubernetes cluster.

2. **Generate KUBECONFIG**:
   - Run the following command in the IBM Cloud CLI:
     ```bash
     ibmcloud ks cluster-config --cluster <CLUSTER_NAME>
     ```
   - This will output the location of your `KUBECONFIG` file.

3. **Store as GitHub Secret**:
   - Go to your GitHub repository.
   - Navigate to **Settings > Secrets and variables > Actions**.
   - Add a new secret named `KUBECONFIG` and paste the contents of the file.

### Best Practices
- **Never Commit Secrets**: Do not store sensitive data directly in the repository.
- **Rotate Secrets Regularly**: Update secrets periodically to enhance security.
- **Use Least Privilege**: Limit permissions associated with secrets.

---

## FAQ

### Q: How do I customize the Helm deployment?
Update the `helm-deploy` action to accept additional inputs in `action.yml`, such as the Helm chart path or release name.

### Q: What if I need to use a different version of the action?
Specify the version in your workflow file, e.g., `@v2.0.0`. Ensure that the referenced version exists as a tag in the repository.

### Q: How do I test this action?
Use the provided example workflow (`example-helm-deploy.yml`) to test the functionality directly within the `github-actions-templates` repository.

---