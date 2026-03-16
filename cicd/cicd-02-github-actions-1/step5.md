# Шаг 5: Переменные окружения и контекст

## Контекст: ${{ github.* }}

Контекст — это автоматические переменные которые GitHub подставляет в каждый workflow. Синтаксис: `${{ выражение }}`.

```bash
cd /opt/gh-actions-demo
```{{execute}}

```bash
cat > .github/workflows/context-demo.yml << 'WORKFLOW'
name: Context Demo

on: push

jobs:
  show-context:
    runs-on: ubuntu-latest
    steps:
      - name: Show GitHub context
        run: |
          echo "===== ИНФОРМАЦИЯ О ЗАПУСКЕ ====="
          echo "Событие:     ${{ github.event_name }}"
          echo "Репозиторий: ${{ github.repository }}"
          echo "Ветка:       ${{ github.ref_name }}"
          echo "SHA коммита: ${{ github.sha }}"
          echo "Автор:       ${{ github.actor }}"
          echo "Run Number:  ${{ github.run_number }}"
          echo ""
          echo "===== ИНФОРМАЦИЯ О РАННЕРЕ ====="
          echo "OS:   ${{ runner.os }}"
          echo "Arch: ${{ runner.arch }}"
WORKFLOW
```{{execute}}

## Переменные окружения: env

```bash
cat > .github/workflows/env-demo.yml << 'WORKFLOW'
name: Environment Variables

on: push

# Переменные на уровне ВСЕГО workflow — доступны везде
env:
  APP_NAME: "myapp"
  APP_VERSION: "1.0.0"

jobs:
  build:
    runs-on: ubuntu-latest

    # Переменные на уровне JOB — доступны в этом job
    env:
      BUILD_ENV: "production"

    steps:
      - name: Show vars
        run: |
          echo "App: $APP_NAME v$APP_VERSION"
          echo "Env: $BUILD_ENV"

      # Переменные на уровне STEP — только для этого шага
      - name: Step with own vars
        env:
          GREETING: "Привет из step!"
        run: |
          echo "$GREETING"
          echo "Job var всё ещё доступна: $BUILD_ENV"

      # Передача данных между steps через $GITHUB_ENV
      - name: Set dynamic variable
        run: |
          BUILD_TIME=$(date -u +%Y%m%d-%H%M%S)
          echo "BUILD_TIME=$BUILD_TIME" >> $GITHUB_ENV

      - name: Use dynamic variable
        run: |
          echo "Build time: $BUILD_TIME"
          echo "Тег образа: $APP_NAME:$APP_VERSION-$BUILD_TIME"
WORKFLOW
```{{execute}}

## Секреты

```bash
cat > .github/workflows/secrets-demo.yml << 'WORKFLOW'
name: Secrets Demo

on: push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: How secrets work
        run: |
          echo "Секреты задаются в GitHub:"
          echo "Settings -> Secrets and variables -> Actions"
          echo ""
          echo "В workflow используются так:"
          echo "docker login -u dollar{{ secrets.DOCKERHUB_USERNAME }}"
          echo "             -p dollar{{ secrets.DOCKERHUB_TOKEN }}"
          echo ""
          echo "В логах они ВСЕГДА маскируются: ***"
          echo "Никогда не пишите пароли прямо в YAML!"
WORKFLOW
```{{execute}}

```bash
python3 -c "
import yaml, os
d = '/opt/gh-actions-demo/.github/workflows'
for f in sorted(os.listdir(d)):
    try:
        yaml.safe_load(open(f'{d}/{f}'))
        print(f'OK  {f}')
    except Exception as e:
        print(f'ERR {f}: {e}')
"
```{{execute}}
