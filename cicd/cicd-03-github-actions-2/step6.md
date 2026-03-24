# Шаг 6: Полный CI/CD пайплайн — от коммита до Docker Hub

Объединяем всё: тесты, matrix, сборка образа, кэш, push в registry.

```bash
cd /opt/docker-actions-demo
```{{execute}}

```bash
cat > .github/workflows/full-pipeline.yml << 'WORKFLOW'
name: Full CI/CD Pipeline

on:
  push:
    branches: [main, develop]
    tags: ["v*.*.*"]           # Триггер на git-теги: v1.0.0, v2.3.1 и т.д.
  pull_request:
    branches: [main]

# Переменные окружения на уровне workflow
env:
  IMAGE_NAME: docker-actions-demo
  REGISTRY: ghcr.io             # GitHub Container Registry (альтернатива Docker Hub)

jobs:
  # ══════════════════════════════════════════════════════════
  # STAGE 1: LINT
  # ══════════════════════════════════════════════════════════
  lint:
    name: "Lint"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check Python syntax
        run: |
          python3 -m py_compile app.py
          python3 -m py_compile tests.py
          echo "Синтаксис OK"

  # ══════════════════════════════════════════════════════════
  # STAGE 2: TEST (matrix — несколько версий Python)
  # ══════════════════════════════════════════════════════════
  test:
    name: "Test Python ${{ matrix.python-version }}"
    runs-on: ubuntu-latest
    needs: lint

    strategy:
      matrix:
        python-version: ["3.10", "3.11"]
      fail-fast: false

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - name: Run tests
        run: |
          echo "Python: $(python --version)"
          python tests.py

  # ══════════════════════════════════════════════════════════
  # STAGE 3: BUILD & PUSH
  # ══════════════════════════════════════════════════════════
  build-push:
    name: "Build & Push"
    runs-on: ubuntu-latest
    needs: test    # Ждёт ВСЕ matrix jobs из test!

    # outputs — позволяет передать данные в следующие jobs
    outputs:
      image-digest: ${{ steps.build.outputs.digest }}
      image-tags: ${{ steps.meta.outputs.tags }}

    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      # Авторизация — только для push в main или при git-теге
      - name: Login to Docker Hub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      # Умная генерация тегов
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha,prefix=sha-
            type=raw,value=latest,enable=${{ github.ref_name == 'main' }}

      # Сборка и push с кэшем
      - name: Build and push
        id: build
        uses: docker/build-push-action@v5
        with:
          context: .
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          build-args: |
            APP_VERSION=${{ github.ref_name }}
            BUILD_SHA=${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Show result
        run: |
          echo "=== Образ собран и отправлен ==="
          echo "Tags: ${{ steps.meta.outputs.tags }}"
          echo "Digest: ${{ steps.build.outputs.digest }}"

  # ══════════════════════════════════════════════════════════
  # STAGE 4: DEPLOY (только для main ветки)
  # ══════════════════════════════════════════════════════════
  deploy:
    name: "Deploy to Staging"
    runs-on: ubuntu-latest
    needs: build-push
    # Деплоим только из main, не из PR
    if: github.ref_name == 'main' && github.event_name != 'pull_request'

    steps:
      - name: Deploy
        run: |
          echo "============================================"
          echo "  Deploying to staging server"
          echo "  Image: ${{ needs.build-push.outputs.image-tags }}"
          echo "  Digest: ${{ needs.build-push.outputs.image-digest }}"
          echo "============================================"
          echo ""
          echo "В реальном проекте здесь был бы:"
          echo "ssh deploy@staging-server"
          echo "  docker pull username/app:latest"
          echo "  docker compose up -d"
WORKFLOW
```{{execute}}

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/full-pipeline.yml')); print('YAML OK')"
```{{execute}}

## Запускаем полный пайплайн через act

```bash
git add . && git commit -m "Add full CI/CD pipeline"

act push -W .github/workflows/full-pipeline.yml   --pull=false   -P ubuntu-latest=catthehacker/ubuntu:act-latest   --secret DOCKERHUB_USERNAME=testuser   --secret DOCKERHUB_TOKEN=testtoken 2>&1 | grep -E "(Job|Step|success|failure|ERROR|WARN|OK|✅|❌)" | head -50
```{{execute}}

## Что происходит при разных событиях

```bash
cat << 'EOF'
git push в ветку feature/xyz:
  lint ✅ → test ✅ → build (push: false, нет деплоя)

git push в ветку main:
  lint ✅ → test ✅ → build + PUSH в Docker Hub → deploy

git push тега v1.2.3:
  lint ✅ → test ✅ → build + PUSH (теги: 1.2.3, 1.2, latest) → deploy

Открытие Pull Request в main:
  lint ✅ → test ✅ → build (push: false, нет деплоя)
EOF
```{{execute}}
