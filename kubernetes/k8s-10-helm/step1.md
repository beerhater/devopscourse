# Step 1: Install Helm 3 and core concepts

## Install Helm 3

```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```{{execute}}

```bash
helm version
helm version --short
```{{execute}}

## Core concepts

```bash
# Helm vocabulary
cat << 'EOF'
Chart    - Package: templates + values + metadata
Release  - Instance of a chart installed in K8s (like a named install)
Revision - Version of a release (upgrades increase revision number)
Repo     - Registry of charts (like Docker Hub but for Helm charts)
Values   - Configuration injected into templates at install time
EOF
```{{execute}}

```bash
helm help
```{{execute}}

## Helm 3 vs Helm 2

```bash
cat << 'EOF'
Helm 2 (old):
  - Required Tiller server-side component
  - Tiller had full cluster-admin privileges

Helm 3 (current):
  - No Tiller: direct K8s API calls
  - Uses K8s RBAC natively
  - Releases stored as Secrets in namespace
  - 3-way strategic merge diff for upgrades
EOF
```{{execute}}

```bash
# Releases are stored as Secrets
kubectl get secrets -n default | grep helm || echo "No releases yet"
```{{execute}}
