# Шаг 2: pytest — базовый запуск в пайплайне

```bash
cd /opt/autotests-demo
pip3 install pytest pytest-cov pytest-xdist pytest-html 2>/dev/null | tail -3
```{{execute}}

```bash
cat > test_bank.py << 'PYEOF'
import pytest
from bank import BankAccount, InsufficientFundsError, NegativeAmountError


@pytest.fixture
def empty_account():
    return BankAccount("TestUser")

@pytest.fixture
def funded_account():
    return BankAccount("Alice", initial_balance=1000.0)

@pytest.fixture
def two_accounts():
    sender = BankAccount("Sender", 500)
    receiver = BankAccount("Receiver", 100)
    return sender, receiver


class TestAccountCreation:
    def test_create_with_balance(self):
        acc = BankAccount("Bob", 500)
        assert acc.balance == 500
        assert acc.owner == "Bob"

    def test_create_zero_balance(self):
        acc = BankAccount("Zero")
        assert acc.balance == 0

    def test_create_negative_balance_raises(self):
        with pytest.raises(NegativeAmountError):
            BankAccount("Bad", -100)

    def test_repr(self):
        acc = BankAccount("Alice", 100)
        assert "Alice" in repr(acc)


class TestDeposit:
    def test_deposit_increases_balance(self, funded_account):
        initial = funded_account.balance
        funded_account.deposit(500)
        assert funded_account.balance == initial + 500

    def test_deposit_returns_new_balance(self, empty_account):
        result = empty_account.deposit(300)
        assert result == 300

    def test_deposit_zero_raises(self, empty_account):
        with pytest.raises(NegativeAmountError):
            empty_account.deposit(0)

    def test_deposit_negative_raises(self, empty_account):
        with pytest.raises(NegativeAmountError):
            empty_account.deposit(-50)

    def test_multiple_deposits(self, empty_account):
        empty_account.deposit(100)
        empty_account.deposit(200)
        empty_account.deposit(300)
        assert empty_account.balance == 600


class TestWithdraw:
    def test_withdraw_decreases_balance(self, funded_account):
        funded_account.withdraw(300)
        assert funded_account.balance == 700

    def test_withdraw_entire_balance(self, funded_account):
        funded_account.withdraw(1000)
        assert funded_account.balance == 0

    def test_withdraw_insufficient_funds(self, funded_account):
        with pytest.raises(InsufficientFundsError) as exc_info:
            funded_account.withdraw(1500)
        assert "Insufficient funds" in str(exc_info.value)

    def test_withdraw_zero_raises(self, funded_account):
        with pytest.raises(NegativeAmountError):
            funded_account.withdraw(0)


class TestTransfer:
    def test_transfer_moves_money(self, two_accounts):
        sender, receiver = two_accounts
        sender.transfer(receiver, 200)
        assert sender.balance == 300
        assert receiver.balance == 300

    def test_transfer_insufficient_funds(self, two_accounts):
        sender, receiver = two_accounts
        with pytest.raises(InsufficientFundsError):
            sender.transfer(receiver, 1000)
        assert sender.balance == 500
        assert receiver.balance == 100


@pytest.mark.parametrize("amount,expected", [
    (100, 100),
    (0.01, 0.01),
    (1_000_000, 1_000_000),
    (99.99, 99.99),
])
def test_deposit_parametrized(empty_account, amount, expected):
    empty_account.deposit(amount)
    assert empty_account.balance == pytest.approx(expected)


class TestStatement:
    def test_empty_statement(self, empty_account):
        assert empty_account.get_statement() == []

    def test_statement_records_deposit(self, empty_account):
        empty_account.deposit(100)
        stmt = empty_account.get_statement()
        assert len(stmt) == 1
        assert stmt[0] == ("deposit", 100)

    def test_statement_records_operations(self, funded_account):
        funded_account.deposit(500)
        funded_account.withdraw(200)
        stmt = funded_account.get_statement()
        assert ("deposit", 500) in stmt
        assert ("withdraw", 200) in stmt
PYEOF
```{{execute}}

```bash
python3 -m pytest test_bank.py -v --tb=short
```{{execute}}

```bash
# Запуск конкретного класса
python3 -m pytest test_bank.py::TestDeposit -v
```{{execute}}

```bash
# Фильтр по имени теста
python3 -m pytest test_bank.py -k "withdraw" -v
```{{execute}}

```bash
# GitHub Actions workflow
mkdir -p .github/workflows
cat > .github/workflows/pytest.yml << 'WORKFLOW'
name: Python Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: pip install pytest pytest-cov pytest-xdist pytest-html
      - name: Запуск тестов
        run: |
          python3 -m pytest test_bank.py -v --tb=short --junitxml=test-results.xml
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results
          path: test-results.xml
WORKFLOW
```{{execute}}

```bash
# GitLab CI
cat > .gitlab-ci.yml << 'GLCI'
stages: [test]
pytest:
  stage: test
  image: python:3.11-slim
  before_script:
    - pip install pytest pytest-cov pytest-html 2>/dev/null | tail -3
  script:
    - python3 -m pytest test_bank.py -v --tb=short --junitxml=report.xml
  artifacts:
    when: always
    reports:
      junit: report.xml
    expire_in: 1 week
GLCI
python3 -c "import yaml; yaml.safe_load(open('.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}
