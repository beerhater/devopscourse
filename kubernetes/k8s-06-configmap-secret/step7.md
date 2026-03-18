# Шаг 7: Immutable ConfigMap и Secret

`immutable: true` — защита от случайного изменения и ускорение кластера (kubelet не следит за обновлениями).

```bash
cat > immutable.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-version-config
data:
  APP_VERSION: "1.5.2"
  BUILD_DATE: "2026-03-18"
  GIT_COMMIT: "a1b2c3d4"
immutable: true              # Нельзя изменить — только удалить и пересоздать
---
apiVersion: v1
kind: Secret
metadata:
  name: immutable-creds
type: Opaque
stringData:
  DB_PASSWORD: "production-password-xyz"
immutable: true
EOF
kubectl apply -f immutable.yaml
```{{execute}}

```bash
# Попытка изменить иммутабельный ConfigMap — получим ошибку
kubectl patch configmap app-version-config   --patch '{"data":{"APP_VERSION":"2.0.0"}}' || echo "Ошибка: нельзя изменить immutable ConfigMap!"
```{{execute}}

```bash
# Правильный подход: новая версия — новый ConfigMap
cat > app-version-config-v2.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-version-config-v2
data:
  APP_VERSION: "2.0.0"
  BUILD_DATE: "2026-03-18"
  GIT_COMMIT: "e5f6g7h8"
immutable: true
EOF
kubectl apply -f app-version-config-v2.yaml
kubectl get configmaps | grep app-version
```{{execute}}

## Когда использовать immutable

- Версионированные конфиги (v1, v2, v3...)
- Credentials продакшна — защита от случайной перезаписи
- Оптимизация: тысячи подов в кластере — kubelet не мониторит каждый CM

```bash
# Удаляем иммутабельный — можно только так обновить
kubectl delete configmap app-version-config
kubectl apply -f immutable.yaml  # Пересоздаём с теми же данными
```{{execute}}
