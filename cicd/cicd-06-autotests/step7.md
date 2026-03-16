# Step 7: Final task

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
            _, current_qty = self._items[product.name]
            self._items[product.name] = (product, current_qty + quantity)
        else:
            self._items[product.name] = (product, quantity)

    def remove(self, product_name: str) -> None:
        if product_name not in self._items:
            raise ProductNotFoundError(f"Product {product_name!r} not found in cart")
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
def sample_products():
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
def cart_with_items(sample_products):
    cart = ShoppingCart()
    cart.add(sample_products["apple"], 3)
    cart.add(sample_products["bread"], 2)
    return cart


class TestProduct:
    def test_create_product(self):
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

    def test_repr(self):
        assert "apple" in repr(Product("apple", 1.5, 10))


class TestShoppingCart:
    def test_empty_cart(self, empty_cart):
        assert empty_cart.total == 0
        assert empty_cart.item_count == 0
        assert len(empty_cart) == 0

    def test_add_product(self, empty_cart, sample_products):
        empty_cart.add(sample_products["apple"])
        assert empty_cart.item_count == 1

    def test_add_multiple_qty(self, empty_cart, sample_products):
        empty_cart.add(sample_products["apple"], 5)
        assert empty_cart.item_count == 5

    def test_total_calculation(self, cart_with_items):
        assert cart_with_items.total == pytest.approx(8.50)

    def test_remove_product(self, cart_with_items):
        cart_with_items.remove("apple")
        assert cart_with_items.total == pytest.approx(4.00)

    def test_remove_nonexistent_raises(self, empty_cart):
        with pytest.raises(ProductNotFoundError):
            empty_cart.remove("nonexistent")

    def test_out_of_stock(self, empty_cart, sample_products):
        with pytest.raises(OutOfStockError):
            empty_cart.add(sample_products["laptop"], 100)

    def test_add_zero_qty_raises(self, empty_cart, sample_products):
        with pytest.raises(ValueError):
            empty_cart.add(sample_products["apple"], 0)

    def test_clear_cart(self, cart_with_items):
        cart_with_items.clear()
        assert cart_with_items.total == 0 and len(cart_with_items) == 0

    def test_add_same_product_twice(self, empty_cart, sample_products):
        empty_cart.add(sample_products["apple"], 2)
        empty_cart.add(sample_products["apple"], 3)
        assert empty_cart.item_count == 5


class TestDiscount:
    @pytest.mark.parametrize("percent,expected", [
        (10,  pytest.approx(7.65)),
        (50,  pytest.approx(4.25)),
        (100, pytest.approx(0.0)),
        (25,  pytest.approx(6.375)),
    ])
    def test_discount(self, cart_with_items, percent, expected):
        assert cart_with_items.apply_discount(percent) == expected

    def test_invalid_discount_zero(self, cart_with_items):
        with pytest.raises(ValueError):
            cart_with_items.apply_discount(0)

    def test_invalid_discount_over_100(self, cart_with_items):
        with pytest.raises(ValueError):
            cart_with_items.apply_discount(101)

    def test_discount_on_empty_cart(self, empty_cart):
        assert empty_cart.apply_discount(10) == 0.0

if __name__ == "__main__":
    pytest.main([__file__, "-v"])
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
    unit: fast unit tests
    slow: slow tests
EOF
```{{execute}}

```bash
python3 -m pytest test_shop.py 2>/dev/null
```{{execute}}

```bash
mkdir -p .github/workflows
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
```{{execute}}

```bash
python3 -c "
import xml.etree.ElementTree as ET
tree = ET.parse('junit-report.xml')
suite = tree.getroot().find('testsuite') or tree.getroot()
print(f'Tests: {suite.get("tests")}')
print(f'Failures: {suite.get("failures")}')
print(f'Time: {float(suite.get("time", 0)):.2f}s')
"
```{{execute}}
