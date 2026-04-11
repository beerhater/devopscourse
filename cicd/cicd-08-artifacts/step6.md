# Шаг 6: Собираем финальный workflow

Сведите идеи урока в один workflow.

```bash
cat > /root/cicd_artifacts_final.yml <<'EOF'
name: artifacts-final

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          mkdir -p dist reports
          echo "release build" > dist/release.txt
          echo "<testsuite></testsuite>" > reports/junit.xml
      - uses: actions/upload-artifact@v4
        with:
          name: release-bundle
          path: |
            dist/
            reports/
          retention-days: 7
EOF

cat /root/cicd_artifacts_final.yml
```{{execute}}
