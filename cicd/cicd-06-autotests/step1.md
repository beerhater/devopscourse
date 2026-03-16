# Step 1: Why tests in CI

## Test pyramid

```bash
mkdir -p /opt/autotests-demo
cat > /opt/autotests-demo/pyramid.txt << 'EOF'
         /        /  \          E2E tests (Selenium, Playwright)
       / E2E\         Slow, expensive, fragile
      /------\        Few: 5-10 tests
     /            /Integration\     Integration tests (API, DB)
   /------------\     Medium speed, medium count: 50-100
  /               /   Unit Tests   \   Unit tests (functions, classes)
/------------------\  Fast, isolated, many: 500+

CI STRATEGY:
  Every push    -> Unit + Integration (< 2 min)
  Every MR      -> Unit + Integration + some E2E
  Nightly       -> Full run including slow E2E
EOF
cat /opt/autotests-demo/pyramid.txt
```{{execute}}

## Create the demo project

```bash
cd /opt/autotests-demo
```{{execute}}

```bash
cat > bank.py << 'PYEOF'
class InsufficientFundsError(Exception):
    pass

class NegativeAmountError(Exception):
    pass

class BankAccount:
    def __init__(self, owner: str, initial_balance: float = 0):
        if initial_balance < 0:
            raise NegativeAmountError("Initial balance cannot be negative")
        self.owner = owner
        self._balance = initial_balance
        self._transactions = []

    @property
    def balance(self) -> float:
        return self._balance

    def deposit(self, amount: float) -> float:
        if amount <= 0:
            raise NegativeAmountError(f"Deposit must be > 0, got: {amount}")
        self._balance += amount
        self._transactions.append(("deposit", amount))
        return self._balance

    def withdraw(self, amount: float) -> float:
        if amount <= 0:
            raise NegativeAmountError(f"Withdraw must be > 0, got: {amount}")
        if amount > self._balance:
            raise InsufficientFundsError(
                f"Insufficient funds: balance {self._balance}, requested {amount}"
            )
        self._balance -= amount
        self._transactions.append(("withdraw", amount))
        return self._balance

    def transfer(self, target: "BankAccount", amount: float) -> None:
        self.withdraw(amount)
        target.deposit(amount)

    def get_statement(self) -> list:
        return list(self._transactions)

    def __repr__(self):
        return f"BankAccount(owner={self.owner!r}, balance={self._balance})"
PYEOF
```{{execute}}

```bash
python3 -c "
from bank import BankAccount
acc = BankAccount('Alice', 1000)
acc.deposit(500)
acc.withdraw(200)
print(f'Balance: {acc.balance}')
print(f'Transactions: {acc.get_statement()}')
print('bank.py OK!')
"
```{{execute}}
