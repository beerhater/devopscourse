# Step 4: JUnit XML and HTML Reports

```bash
cd /opt/autotests-demo
```{{execute}}

```bash
python3 -m pytest test_bank.py --junitxml=junit-report.xml -v 2>/dev/null
```{{execute}}

```bash
python3 << 'PYEOF'
import xml.etree.ElementTree as ET
tree = ET.parse("junit-report.xml")
root = tree.getroot()
suite = root.find("testsuite") or root
print(f"Total: {suite.get('tests')}")
print(f"Failures: {suite.get('failures', '0')}")
print(f"Time: {suite.get('time')}s")
print()
for tc in suite.findall(".//testcase"):
    name = tc.get("name", "")
    t = tc.get("time", "0")
    fail = tc.find("failure")
    status = "FAIL" if fail is not None else "PASS"
    print(f"  [{status}] {name} ({t}s)")
PYEOF
```{{execute}}

```bash
python3 -m pytest test_bank.py   --html=pytest-report.html   --self-contained-html   -v 2>/dev/null
ls -lh pytest-report.html
```{{execute}}

```bash
cat > test_broken.py << 'PYEOF'
import pytest
from bank import BankAccount, InsufficientFundsError

def test_this_will_pass():
    acc = BankAccount("Alice", 100)
    assert acc.balance == 100

def test_this_will_fail():
    acc = BankAccount("Bob", 500)
    acc.withdraw(200)
    assert acc.balance == 200, f"Expected 200, got {acc.balance}"

def test_this_will_error():
    acc = BankAccount("Charlie", 100)
    acc.nonexistent_method()
PYEOF
```{{execute}}

```bash
python3 -m pytest test_broken.py   --junitxml=broken-report.xml   --tb=short -v 2>/dev/null || true
```{{execute}}

```bash
python3 << 'PYEOF'
import xml.etree.ElementTree as ET
tree = ET.parse("broken-report.xml")
suite = tree.getroot().find("testsuite") or tree.getroot()
print("=== FAILED TESTS ===")
for tc in suite.findall(".//testcase"):
    fail = tc.find("failure")
    err = tc.find("error")
    if fail is not None or err is not None:
        name = tc.get("name")
        msg = (fail or err).get("message", "")[:100]
        print(f"  Test: {name}")
        print(f"  Reason: {msg}")
PYEOF
```{{execute}}

```bash
cat > .gitlab-ci.yml << 'GLCI'
stages: [test]
variables:
  PIP_DEPS: "pytest pytest-cov pytest-html"
.pytest-base:
  image: python:3.11-slim
  before_script:
    - pip install $PIP_DEPS 2>/dev/null | tail -2
unit-tests:
  extends: .pytest-base
  stage: test
  script:
    - mkdir -p junit html
    - python3 -m pytest test_bank.py
        -v --tb=short
        --junitxml=junit/unit-report.xml
        --html=html/unit-report.html --self-contained-html
        --cov=bank --cov-report=xml:coverage.xml --cov-fail-under=75
  coverage: '/TOTAL.*\s+(\d+%)$/'
  artifacts:
    when: always
    paths: [junit/, html/, coverage.xml]
    reports:
      junit: junit/unit-report.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
    expire_in: 2 weeks
GLCI
python3 -c "import yaml; yaml.safe_load(open('.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}

```bash
gitlab-runner exec shell unit-tests 2>&1 | grep -E "(PASSED|FAILED|ERROR|coverage)" | head -20
```{{execute}}
