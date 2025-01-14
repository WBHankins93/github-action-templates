# GitHub Actions Templates

## Overview
This repository contains reusable GitHub Actions workflows and composite actions for CI/CD, Docker builds, and Kubernetes deployments.

## Workflows
- `ci-cd.yaml`: A reusable CI/CD pipeline.
- `build-docker.yaml`: Build and push Docker images to a container registry.

## Actions
- `helm-deploy`: A composite action for deploying Helm charts to a Kubernetes cluster.

## Usage
Reference these workflows or actions from other repositories.

### Example: Using `ci-cd.yaml` Workflow
Add this to your `.github/workflows/deploy.yml`:
```yaml
jobs:
  deploy:
    uses: your-org/github-actions-templates/.github/workflows/ci-cd.yaml@main
    with:
      branch: "main"
      kubernetes_namespace: "default"
