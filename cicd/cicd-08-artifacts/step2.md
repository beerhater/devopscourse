# Шаг 2: Сохраняем test report как artifact

Часто в pipeline нужно сохранять не только build-артефакт, но и отчёт тестов.

```bash
cat > /root/cicd_artifacts_reports.yml <<'EOF'
name: test-reports

on:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          mkdir -p reports
          echo "<testsuite></testsuite>" > reports/junit.xml
      - uses: actions/upload-artifact@v4
        with:
          name: junit-report
          path: reports/junit.xml
EOF

cat /root/cicd_artifacts_reports.yml
```{{execute}}
