# Шаг 1: Добавляем matrix strategy

Создайте workflow, который проверяет проект на двух версиях Node.js.

```bash
mkdir -p /root/cicd-matrix/.github/workflows

cat > /root/cicd-matrix/.github/workflows/matrix.yml <<'EOF'
name: matrix-demo

on:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [18, 20]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      - run: echo "Testing on Node ${{ matrix.node }}"
EOF

cp /root/cicd-matrix/.github/workflows/matrix.yml /root/cicd_matrix_result.yml
cat /root/cicd_matrix_result.yml
```{{execute}}

Это базовый шаблон для параллельной проверки нескольких вариантов среды.
