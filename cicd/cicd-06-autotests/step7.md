# Шаг 7: Итоговое задание

```bash
mkdir -p /opt/final-autotests && cd /opt/final-autotests
pip install pytest pytest-cov pytest-xdist pytest-html 2>/dev/null | tail -2
```{{execute}}

```bash
cat > shop.py << 'PYEOF'
class ProductNotFoundError(Exception):
    pass

class OutOfStockError(Exception):
    pass

class Product:
    def __init__(self, name: str, price: float, stock: int):
        if price < 0:
            raise ValueError("Price cannot be negative")
        if stock < 0:
            raise ValueError("Stock cannot be negative")
        self.name = name
        self.price = price
        self.stock = stock

    def __repr__(self):
        return f"Product({self.name!r}, {self.price}, stock={self.stock})"


class ShoppingCart:
    def __init__(self):
        self._items: dict = {}

    def add(self, product: Product, quantity: int = 1) -> None:
        if quantity <= 0:
            raise ValueError("Quantity must be > 0")
        if product.stock < quantity:
            raise OutOfStockError(
                f"Out of stock: {product.name!r}: have {product.stock}, requested {quantity}"
            )
        if product.name in self._items:
            _, cur = self._items[product.name]
            self._items[product.name] = (product, cur + quantity)
        else:
            self._items[product.name] = (product, quantity)

    def remove(self, product_name: str) -> None:
        if product_name not in self._items:
            raise ProductNotFoundError(f"Product {product_name!r} not found")
        del self._items[product_name]

    @property
    def total(self) -> float:
        return sum(p.price * qty for p, qty in self._items.values())

    @property
    def item_count(self) -> int:
        return sum(qty for _, qty in self._items.values())

    def apply_discount(self, percent: float) -> float:
        if not 0 < percent <= 100:
            raise ValueError("Discount must be between 0 and 100%")
        return self.total * (1 - percent / 100)

    def clear(self) -> None:
        self._items.clear()

    def __len__(self):
        return len(self._items)
PYEOF
```{{execute}}

```bash
cat > test_shop.py << 'PYEOF'
import pytest
from shop import Product, ShoppingCart, ProductNotFoundError, OutOfStockError


@pytest.fixture
def products():
    return {
        "apple":  Product("apple",  1.50, 100),
        "bread":  Product("bread",  2.00, 50),
        "milk":   Product("milk",   1.20, 30),
        "laptop": Product("laptop", 999.0, 5),
    }

@pytest.fixture
def empty_cart():
    return ShoppingCart()

@pytest.fixture
def cart(products):
    c = ShoppingCart()
    c.add(products["apple"], 3)
    c.add(products["bread"], 2)
    return c


class TestProduct:
    def test_create(self):
        p = Product("test", 10.0, 5)
        assert p.name == "test" and p.price == 10.0 and p.stock == 5

    def test_negative_price_raises(self):
        with pytest.raises(ValueError):
            Product("bad", -1.0, 10)

    def test_negative_stock_raises(self):
        with pytest.raises(ValueError):
            Product("bad", 10.0, -5)

    def test_zero_price_ok(self):
        assert Product("free", 0.0, 10).price == 0.0


class TestCart:
    def test_empty_cart(self, empty_cart):
        assert empty_cart.total == 0 and empty_cart.item_count == 0

    def test_add_product(self, empty_cart, products):
        empty_cart.add(products["apple"])
        assert empty_cart.item_count == 1

    def test_total(self, cart):
        assert cart.total == pytest.approx(8.50)

    def test_remove(self, cart):
        cart.remove("apple")
        assert cart.total == pytest.approx(4.00)

    def test_remove_nonexistent(self, empty_cart):
        with pytest.raises(ProductNotFoundError):
            empty_cart.remove("ghost")

    def test_out_of_stock(self, empty_cart, products):
        with pytest.raises(OutOfStockError):
            empty_cart.add(products["laptop"], 100)

    def test_add_zero_qty(self, empty_cart, products):
        with pytest.raises(ValueError):
            empty_cart.add(products["apple"], 0)

    def test_clear(self, cart):
        cart.clear()
        assert cart.total == 0 and len(cart) == 0

    def test_add_same_product_twice(self, empty_cart, products):
        empty_cart.add(products["apple"], 2)
        empty_cart.add(products["apple"], 3)
        assert empty_cart.item_count == 5


class TestDiscount:
    @pytest.mark.parametrize("pct,expected", [
        (10,  pytest.approx(7.65)),
        (50,  pytest.approx(4.25)),
        (100, pytest.approx(0.0)),
    ])
    def test_discount(self, cart, pct, expected):
        assert cart.apply_discount(pct) == expected

    def test_invalid_zero(self, cart):
        with pytest.raises(ValueError):
            cart.apply_discount(0)

    def test_invalid_over_100(self, cart):
        with pytest.raises(ValueError):
            cart.apply_discount(101)
PYEOF
```{{execute}}

```bash
cat > pytest.ini << 'EOF'
[pytest]
addopts =
    -v
    --tb=short
    --cov=shop
    --cov-report=term-missing
    --cov-report=html:coverage-html
    --cov-report=xml:coverage.xml
    --cov-fail-under=80
    --junitxml=junit-report.xml

markers =
    unit: быстрые unit тесты
    slow: медленные тесты
EOF
```{{execute}}

```bash
python3 -m pytest test_shop.py 2>/dev/null
```{{execute}}

```bash
# Финальный GitHub Actions
cat > .github/workflows/ci.yml << 'WORKFLOW'
name: Shop Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11"]
      fail-fast: false
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: pip install pytest pytest-cov pytest-xdist pytest-html
      - run: python3 -m pytest test_shop.py -n auto
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: reports-${{ matrix.python-version }}
          path: |
            junit-report.xml
            coverage-html/
WORKFLOW
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml')); print('YAML OK')"
```{{execute}}

```bash
python3 -c "
import xml.etree.ElementTree as ET
tree = ET.parse('junit-report.xml')
suite = tree.getroot().find('testsuite') or tree.getroot()
print(f'Тестов: {suite.get("tests")}')
print(f'Ошибок: {suite.get("failures")}')
print(f'Время: {float(suite.get("time", 0)):.2f}с')
"
```{{execute}}
