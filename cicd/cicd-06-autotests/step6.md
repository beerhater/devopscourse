# Step 6: Parallel runs and fail-fast

```bash
cd /opt/autotests-demo
```{{execute}}

```bash
echo "=== Sequential ==="
time python3 -m pytest test_bank.py -q --no-cov 2>/dev/null
```{{execute}}

```bash
echo "=== Parallel (2 workers) ==="
time python3 -m pytest test_bank.py -q -n 2 --no-cov 2>/dev/null
```{{execute}}

```bash
cat > test_strategies.py << 'PYEOF'
import pytest
from bank import BankAccount, InsufficientFundsError

@pytest.mark.unit
class TestFast:
    def test_create(self):
        assert BankAccount("T", 100).balance == 100

    def test_deposit(self):
        acc = BankAccount("T")
        acc.deposit(50)
        assert acc.balance == 50

    def test_withdraw(self):
        acc = BankAccount("T", 200)
        acc.withdraw(100)
        assert acc.balance == 100

@pytest.mark.slow
class TestSlow:
    def test_many_transactions(self):
        acc = BankAccount("Heavy", 10000)
        for i in range(100):
            acc.deposit(10)
            acc.withdraw(10)
        assert acc.balance == 10000

    def test_bulk_transfer(self):
        accounts = [BankAccount(f"User{i}", 1000) for i in range(10)]
        for i in range(len(accounts) - 1):
            accounts[i].transfer(accounts[i+1], 100)
        assert accounts[-1].balance > 1000
PYEOF
```{{execute}}

```bash
python3 -m pytest test_strategies.py -m "unit" -v --no-cov 2>/dev/null
```{{execute}}

```bash
cat > test_failfast.py << 'PYEOF'
from bank import BankAccount

def test_1_passes():
    assert BankAccount("A", 100).balance == 100

def test_2_FAILS():
    acc = BankAccount("B", 100)
    assert acc.balance == 999, "Intentionally broken"

def test_3_would_pass():
    assert 1 + 1 == 2
PYEOF
```{{execute}}

```bash
echo "=== Without -x: all tests run ==="
python3 -m pytest test_failfast.py -v --no-cov 2>/dev/null || true
echo ""
echo "=== With -x: stop on first failure ==="
python3 -m pytest test_failfast.py -v -x --no-cov 2>/dev/null || true
```{{execute}}

```bash
mkdir -p .github/workflows
cat > .github/workflows/smart-tests.yml << 'WORKFLOW'
name: Smart Test Strategy
on: [push, pull_request]
jobs:
  unit-tests:
    name: "Unit Tests (fast)"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.11" }
      - run: pip install pytest pytest-cov pytest-xdist
      - run: |
          python3 -m pytest test_bank.py -m "unit or not slow"             -n auto -x --tb=short --junitxml=unit-results.xml
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: unit-results
          path: unit-results.xml

  full-tests:
    name: "Full Tests + Coverage"
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.11" }
      - run: pip install pytest pytest-cov pytest-xdist
      - run: |
          python3 -m pytest test_bank.py -n auto             --cov=bank --cov-report=term-missing             --cov-report=html:coverage-html             --cov-fail-under=75 --junitxml=full-results.xml
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: full-results
          path: |
            full-results.xml
            coverage-html/

  compatibility:
    name: "Python ${{ matrix.python-version }}"
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    strategy:
      matrix:
        python-version: ["3.9", "3.10", "3.11", "3.12"]
      fail-fast: false
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: pip install pytest
      - run: python3 -m pytest test_bank.py -q
WORKFLOW
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/smart-tests.yml')); print('YAML OK')"
```{{execute}}
