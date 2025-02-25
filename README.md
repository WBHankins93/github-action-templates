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


#### **Multi-Environment Deployment Workflow**
**Location**: `workflows/multi-env-deploy.yaml`

This workflow allows deployments to multiple environments (e.g., dev, staging, prod) based on the branch or tags pushed.

```yaml
name: Multi-Environment Deployment

on:
  push:
    branches:
      - "main"
      - "develop"
    tags:
      - "v*"

jobs:
  deploy:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        environment: ["dev", "staging", "prod"]
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Set Environment Variables
        run: |
          if [ "${{ matrix.environment }}" == "dev" ]; then
            echo "DEPLOY_NAMESPACE=development" >> $GITHUB_ENV
          elif [ "${{ matrix.environment }}" == "staging" ]; then
            echo "DEPLOY_NAMESPACE=staging" >> $GITHUB_ENV
          elif [ "${{ matrix.environment }}" == "prod" ]; then
            echo "DEPLOY_NAMESPACE=production" >> $GITHUB_ENV
          fi

      - name: Deploy to Kubernetes
        uses: ./actions/helm-deploy
        with:
          namespace: ${{ env.DEPLOY_NAMESPACE }}
```


## **Helm Deployment Workflow**

This repository includes a reusable GitHub Actions workflow and script to deploy Helm charts to a Kubernetes cluster.

---

## How to Use

### 1. GitHub Actions Workflow
The workflow is defined in `.github/workflows/deploy-helm.yml`. It supports manual triggering with dynamic namespace inputs.

- **For a New Cluster:**
  Replace `secrets.KUBECONFIG` in the workflow with your specific kubeconfig or authentication setup.

- **For New Helm Charts:**
  Update the `helm upgrade --install` command in the `deploy.sh` script with the path to your Helm chart and relevant `--set` options.

- **For Different Environments:**
  Use the `namespace` input when triggering the workflow to specify the target environment dynamically.

### 2. Shell Script
The script is located at the root of the repository (`deploy.sh`) and handles:
- Verifying or creating the target namespace.
- Performing idempotent Helm deployments using `helm upgrade --install`.
- Supporting custom Helm parameters.

---

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


## FAQ

### Q: How do I customize the Helm deployment?
Update the `helm-deploy` action to accept additional inputs in `action.yml`, such as the Helm chart path or release name.

### Q: What if I need to use a different version of the action?
Specify the version in your workflow file, e.g., `@v2.0.0`. Ensure that the referenced version exists as a tag in the repository.

### Q: How do I test this action?
Use the provided example workflow (`example-helm-deploy.yml`) to test the functionality directly within the `github-actions-templates` repository.

---