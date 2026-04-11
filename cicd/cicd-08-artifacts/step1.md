# Шаг 1: Добавляем artifact в workflow

Соберите маленький workflow, который создаёт build-артефакт и публикует его.

```bash
mkdir -p /root/cicd-artifacts/.github/workflows /root/cicd-artifacts/dist

cat > /root/cicd-artifacts/.github/workflows/artifacts.yml <<'EOF'
name: build-artifacts

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build release file
        run: |
          mkdir -p dist
          echo "release build" > dist/release.txt
      - name: Upload build artifact
        uses: actions/upload-artifact@v4
        with:
          name: release-files
          path: dist/
EOF

cp /root/cicd-artifacts/.github/workflows/artifacts.yml /root/cicd_artifacts_result.yml
cat /root/cicd_artifacts_result.yml
```{{execute}}

Это база для передачи результатов между stage и для последующего анализа build outputs.
