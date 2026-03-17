# Шаг 8: kubectl rollout в CI/CD пайплайне

На практике деплой через Deployment — это 3 команды в пайплайне.

## Базовый паттерн деплоя

```bash
cd /tmp && mkdir -p ci-demo && cd ci-demo
```{{execute}}

```bash
cat > deploy.sh << 'BASH'
#!/bin/bash
set -e

IMAGE=${1:-nginx:alpine}
DEPLOYMENT=${2:-web-app}
TIMEOUT=${3:-120s}

echo "=== ДЕПЛОЙ ==="
echo "Deployment: $DEPLOYMENT"
echo "Image: $IMAGE"
echo ""

# 1. Обновляем образ
echo "1. Обновляем образ..."
kubectl set image deployment/$DEPLOYMENT nginx=$IMAGE

# 2. Аннотируем для истории
kubectl annotate deployment $DEPLOYMENT   kubernetes.io/change-cause="image=$IMAGE ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)"   --overwrite

# 3. Ждём завершения rollout
echo "2. Ждём rollout..."
if kubectl rollout status deployment/$DEPLOYMENT --timeout=$TIMEOUT; then
  echo ""
  echo "✓ ДЕПЛОЙ УСПЕШЕН"
  kubectl get deployment $DEPLOYMENT
else
  echo ""
  echo "✗ ТАЙМАУТ — откатываемся!"
  kubectl rollout undo deployment/$DEPLOYMENT
  kubectl rollout status deployment/$DEPLOYMENT --timeout=60s
  echo "✓ Откат завершён"
  exit 1
fi
BASH
chmod +x deploy.sh
```{{execute}}

```bash
# Деплоим рабочий образ
./deploy.sh nginx:1.25-alpine web-app
```{{execute}}

```bash
# Деплоим несуществующий образ — скрипт автоматически откатится
./deploy.sh nginx:999-bad web-app 20s || true
```{{execute}}

```bash
# Итоговая история
kubectl rollout history deployment/web-app
```{{execute}}

## GitHub Actions фрагмент

```bash
cat > .github-ci-fragment.yml << 'EOF'
# Фрагмент GitHub Actions job для деплоя в K8s
deploy:
  runs-on: ubuntu-latest
  needs: [build, test]
  steps:
    - name: Configure kubectl
      uses: azure/k8s-set-context@v4
      with:
        kubeconfig: ${{ secrets.KUBECONFIG }}

    - name: Deploy
      run: |
        kubectl set image deployment/${{ env.DEPLOYMENT }} \
          app=${{ env.REGISTRY }}/${{ env.IMAGE }}:${{ github.sha }}

        kubectl annotate deployment/${{ env.DEPLOYMENT }} \
          kubernetes.io/change-cause="sha=${{ github.sha }} actor=${{ github.actor }}" \
          --overwrite

    - name: Wait for rollout
      run: kubectl rollout status deployment/${{ env.DEPLOYMENT }} --timeout=120s

    - name: Rollback on failure
      if: failure()
      run: kubectl rollout undo deployment/${{ env.DEPLOYMENT }}
EOF
cat .github-ci-fragment.yml
```{{execute}}
