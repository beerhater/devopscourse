# Step 5: go test

```bash
export PATH=$PATH:/usr/local/go/bin
if ! which go > /dev/null 2>&1; then
  wget -qO /tmp/go.tar.gz https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
  tar -C /usr/local -xzf /tmp/go.tar.gz
fi
go version
```{{execute}}

```bash
export PATH=$PATH:/usr/local/go/bin
mkdir -p /opt/go-tests-demo && cd /opt/go-tests-demo
go mod init go-tests-demo
```{{execute}}

```bash
cat > calculator.go << 'GOEOF'
package main

import (
    "errors"
    "math"
)

type Calculator struct{}

func (c *Calculator) Add(a, b float64) float64      { return a + b }
func (c *Calculator) Subtract(a, b float64) float64 { return a - b }
func (c *Calculator) Multiply(a, b float64) float64 { return a * b }

func (c *Calculator) Divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func (c *Calculator) Sqrt(x float64) (float64, error) {
    if x < 0 {
        return 0, errors.New("cannot compute sqrt of negative number")
    }
    return math.Sqrt(x), nil
}

func (c *Calculator) Power(base, exp float64) float64 {
    return math.Pow(base, exp)
}

func main() {}
GOEOF
```{{execute}}

```bash
cat > calculator_test.go << 'GOEOF'
package main

import (
    "testing"
)

func TestAdd(t *testing.T) {
    calc := &Calculator{}
    tests := []struct {
        name     string
        a, b     float64
        expected float64
    }{
        {"positive", 2, 3, 5},
        {"negative", -1, -2, -3},
        {"zero", 0, 0, 0},
        {"mixed", -5, 10, 5},
        {"floats", 1.5, 2.5, 4.0},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := calc.Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%v,%v) = %v, want %v", tt.a, tt.b, result, tt.expected)
            }
        })
    }
}

func TestDivide(t *testing.T) {
    calc := &Calculator{}
    t.Run("normal", func(t *testing.T) {
        result, err := calc.Divide(10, 2)
        if err != nil {
            t.Fatalf("unexpected error: %v", err)
        }
        if result != 5 {
            t.Errorf("Divide(10,2) = %v, want 5", result)
        }
    })
    t.Run("by_zero", func(t *testing.T) {
        _, err := calc.Divide(10, 0)
        if err == nil {
            t.Error("expected error for division by zero")
        }
    })
}

func TestSqrt(t *testing.T) {
    calc := &Calculator{}
    result, err := calc.Sqrt(16)
    if err != nil {
        t.Fatalf("unexpected error: %v", err)
    }
    if result != 4 {
        t.Errorf("Sqrt(16) = %v, want 4", result)
    }
    _, err = calc.Sqrt(-1)
    if err == nil {
        t.Error("expected error for negative number")
    }
}

func TestPower(t *testing.T) {
    calc := &Calculator{}
    tests := []struct{ base, exp, expected float64 }{
        {2, 10, 1024},
        {3, 0, 1},
        {5, 2, 25},
    }
    for _, tt := range tests {
        result := calc.Power(tt.base, tt.exp)
        if result != tt.expected {
            t.Errorf("Power(%v,%v) = %v, want %v", tt.base, tt.exp, result, tt.expected)
        }
    }
}

func BenchmarkAdd(b *testing.B) {
    calc := &Calculator{}
    for i := 0; i < b.N; i++ {
        calc.Add(float64(i), float64(i+1))
    }
}
GOEOF
```{{execute}}

```bash
export PATH=$PATH:/usr/local/go/bin && cd /opt/go-tests-demo
go test ./... -v
```{{execute}}

```bash
go test ./... -cover
```{{execute}}

```bash
go test ./... -coverprofile=coverage.out && go tool cover -func=coverage.out
```{{execute}}

```bash
go test ./... -race -v
```{{execute}}

```bash
go test ./... -bench=. -benchmem
```{{execute}}

```bash
cat > .github/workflows/go-test.yml << 'WORKFLOW'
name: Go Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version: "1.21"
          cache: true
      - run: go test ./... -v -race -coverprofile=coverage.out
      - run: go tool cover -func=coverage.out
      - run: go test ./... -bench=. -benchmem -run=^$
WORKFLOW
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/go-test.yml')); print('YAML OK')"
```{{execute}}
