# Шаг 7: Собираем финальный matrix-workflow

```bash
cat > /root/cicd_matrix_final.yml <<'EOF'
name: matrix-final

on:
  pull_request:

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      max-parallel: 2
      matrix:
        os: [ubuntu-latest, macos-latest]
        node: [18, 20]
        exclude:
          - os: macos-latest
            node: 18
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      - run: echo "Testing on ${{ matrix.os }} / Node ${{ matrix.node }}"
EOF

cat /root/cicd_matrix_final.yml
```{{execute}}
