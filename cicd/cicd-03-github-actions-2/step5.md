# Шаг 5: Matrix builds — тест на нескольких версиях

## Что такое Matrix?

**Matrix** позволяет запустить один и тот же job **несколько раз с разными параметрами**. Это незаменимо когда нужно убедиться что код работает на Python 3.9, 3.10, 3.11 и 3.12 — или на Ubuntu, Windows и macOS одновременно.

Без matrix: вы копируете job 4 раза — дублирование кода.
С matrix: вы описываете job один раз, указываете параметры — GitHub запустит их параллельно.

```bash
cd /opt/docker-actions-demo
```{{execute}}

```bash
cat > .github/workflows/matrix.yml << 'WORKFLOW'
name: Matrix Build

on: push

jobs:
  # ── MATRIX ПО ВЕРСИЯМ PYTHON ────────────────────────────────────
  test-python-versions:
    name: "Test Python ${{ matrix.python-version }}"
    runs-on: ubuntu-latest

    # Определяем матрицу: job запустится для КАЖДОГО значения
    strategy:
      matrix:
        python-version: ["3.9", "3.10", "3.11", "3.12"]

      # fail-fast: false — не отменять другие jobs если одна упала
      # По умолчанию true: если 3.9 упала — 3.10, 3.11, 3.12 отменяются
      # false: все версии проверяются независимо
      fail-fast: false

    steps:
      - uses: actions/checkout@v4

      # Устанавливаем нужную версию Python
      # ${{ matrix.python-version }} — текущее значение из матрицы
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Show Python version
        run: python --version

      - name: Run tests
        run: python tests.py

  # ── MATRIX ПО OS И PYTHON ───────────────────────────────────────
  test-cross-platform:
    name: "Test ${{ matrix.os }} / Python ${{ matrix.python-version }}"
    runs-on: ${{ matrix.os }}   # runner тоже из матрицы!

    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
        python-version: ["3.10", "3.11"]
        # Итого: 4 комбинации запустятся параллельно:
        #   ubuntu / 3.10
        #   ubuntu / 3.11
        #   macos  / 3.10
        #   macos  / 3.11

        # EXCLUDE: исключить конкретную комбинацию
        # exclude:
        #   - os: macos-latest
        #     python-version: "3.10"

        # INCLUDE: добавить комбинацию с дополнительным параметром
        include:
          - os: ubuntu-latest
            python-version: "3.12"
            experimental: true   # Дополнительный параметр только для этой комбинации

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Run tests
        run: python tests.py

      - name: Show matrix info
        run: |
          echo "OS: ${{ matrix.os }}"
          echo "Python: ${{ matrix.python-version }}"
          echo "Experimental: ${{ matrix.experimental }}"

  # ── MATRIX ДЛЯ DOCKER BUILD ─────────────────────────────────────
  docker-matrix:
    name: "Docker ${{ matrix.variant }}"
    runs-on: ubuntu-latest
    needs: test-python-versions  # После того как тесты прошли на всех версиях

    strategy:
      matrix:
        include:
          - variant: "alpine"
            base_image: "python:3.11-alpine"
            tag_suffix: "alpine"
          - variant: "slim"
            base_image: "python:3.11-slim"
            tag_suffix: "slim"

    steps:
      - uses: actions/checkout@v4

      - name: Build ${{ matrix.variant }} variant
        run: |
          cat > Dockerfile.${{ matrix.variant }} << DFILE
          FROM ${{ matrix.base_image }}
          WORKDIR /app
          COPY app.py tests.py requirements.txt .
          RUN python3 tests.py
          CMD ["python3", "app.py"]
          DFILE

          docker build -f Dockerfile.${{ matrix.variant }}             -t demo:${{ matrix.tag_suffix }} .

          echo "=== Размер образа ${{ matrix.variant }} ==="
          docker images demo:${{ matrix.tag_suffix }}
WORKFLOW
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/matrix.yml')); print('YAML OK')"
```{{execute}}

## Визуализация matrix builds

```bash
cat << 'EOF'
Матрица: os × python-version
================================
               Python 3.10    Python 3.11    Python 3.12
ubuntu-latest  [job] ✅       [job] ✅       [job] ✅ (experimental)
macos-latest   [job] ✅       [job] ✅
================================
Все 5 jobs запускаются ПАРАЛЛЕЛЬНО!
Общее время = время самого долгого job, а не сумма всех.
EOF
```{{execute}}
