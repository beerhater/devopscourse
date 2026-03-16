# Step 3: Coverage

```bash
cd /opt/autotests-demo
```{{execute}}

```bash
python3 -m pytest test_bank.py --cov=bank --cov-report=term-missing
```{{execute}}

```bash
python3 -m pytest test_bank.py   --cov=bank   --cov-report=term-missing   --cov-report=html:coverage-html   --cov-report=xml:coverage.xml
```{{execute}}

```bash
python3 -m pytest test_bank.py --cov=bank --cov-fail-under=80 -q
```{{execute}}

```bash
python3 -m pytest test_bank.py --cov=bank --cov-fail-under=100 -q || echo "Coverage below 100%"
```{{execute}}

```bash
cat > pytest.ini << 'EOF'
[pytest]
addopts =
    -v
    --tb=short
    --strict-markers
    --cov=bank
    --cov-report=term-missing
    --cov-report=html:coverage-html
    --cov-report=xml:coverage.xml
    --cov-fail-under=75

markers =
    slow: slow integration tests
    unit: fast unit tests
    integration: integration tests
EOF
```{{execute}}

```bash
python3 -m pytest test_bank.py
```{{execute}}

```bash
cat > .gitlab-ci.yml << 'GLCI'
stages: [test]
pytest-with-coverage:
  stage: test
  image: python:3.11-slim
  before_script:
    - pip install pytest pytest-cov pytest-html 2>/dev/null | tail -3
  script:
    - python3 -m pytest test_bank.py
  coverage: '/TOTAL.*\s+(\d+%)$/'
  artifacts:
    when: always
    paths:
      - coverage-html/
      - coverage.xml
    reports:
      junit: report.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
    expire_in: 1 week
GLCI
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}
