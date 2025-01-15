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