# Step 3: Chart.yaml - metadata and versioning

```bash
cat > myapp-chart/Chart.yaml << 'EOF'
apiVersion: v2
name: myapp-chart
description: A DevOps course demo web application
type: application

# Chart version - bump when chart TEMPLATE changes
version: 0.1.0

# App version - version of the APPLICATION being packaged
appVersion: "1.0.0"

keywords:
- nginx
- web
- devops-course

maintainers:
- name: DevOps Engineer
  email: devops@example.com

home: https://github.com/example/devops-course
sources:
- https://github.com/example/devops-course
EOF
```{{execute}}

```bash
cat myapp-chart/Chart.yaml
```{{execute}}

## apiVersion v1 vs v2

```bash
cat << 'EOF'
apiVersion: v1  -- Helm 2 charts, no dependencies block
apiVersion: v2  -- Helm 3 charts, supports dependencies, type field

type: application  -- regular chart
type: library      -- only helpers, cannot be installed standalone
EOF
```{{execute}}

## Version vs appVersion

```bash
cat << 'EOF'
version: 0.1.0     <- Helm chart version
                      Change when you modify templates or default values
                      Follows semver: MAJOR.MINOR.PATCH

appVersion: "1.0.0" <- Version of the app INSIDE the chart
                       Change when you update the Docker image tag
                       Just a label - Helm does not use it for logic
EOF
```{{execute}}

```bash
# Validate chart is still valid
helm lint myapp-chart
```{{execute}}
