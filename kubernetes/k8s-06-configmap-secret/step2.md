# Шаг 2: Secret — создание и типы

Secret хранит данные в **base64** (не шифрование — только кодирование). В продакшне Secret шифруют через `etcd encryption` или внешние хранилища (Vault, AWS Secrets Manager).

## Типы Secret

| Тип | Назначение |
|-----|-----------|
| `Opaque` | Произвольные данные (по умолчанию) |
| `kubernetes.io/dockerconfigjson` | Credentials для registry |
| `kubernetes.io/tls` | TLS сертификат и ключ |
| `kubernetes.io/service-account-token` | Токен ServiceAccount |

## Opaque Secret — императивно

```bash
kubectl create secret generic db-credentials   --from-literal=DB_USER=admin   --from-literal=DB_PASSWORD=super-secret-password   --from-literal=DB_NAME=myapp
```{{execute}}

```bash
kubectl get secret db-credentials
kubectl describe secret db-credentials
```{{execute}}

```bash
# Значения скрыты в describe — видны только размеры
# Но можно получить через -o yaml + base64 decode
kubectl get secret db-credentials -o yaml
```{{execute}}

```bash
# Декодируем вручную
kubectl get secret db-credentials   -o jsonpath='{.data.DB_PASSWORD}' | base64 -d
echo ""
```{{execute}}

## Secret из файла (например, TLS или SSH-ключ)

```bash
# Генерируем тестовый ключ и сертификат
openssl req -x509 -nodes -days 365 -newkey rsa:2048   -keyout tls.key -out tls.crt   -subj "/CN=myapp.example.com" 2>/dev/null

kubectl create secret tls myapp-tls --cert=tls.crt --key=tls.key
kubectl describe secret myapp-tls
```{{execute}}

## Secret через YAML (значения в base64)

```bash
# Кодируем значения
echo -n "admin" | base64
echo -n "my-api-token-xyz" | base64
```{{execute}}

```bash
cat > secret.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: api-credentials
type: Opaque
data:
  API_USER: YWRtaW4=           # echo -n "admin" | base64
  API_TOKEN: bXktYXBpLXRva2VuLXh5eg==  # echo -n "my-api-token-xyz" | base64
stringData:                    # stringData принимает обычный текст — K8s сам кодирует
  API_URL: "https://api.example.com"
  API_VERSION: "v2"
EOF
kubectl apply -f secret.yaml
kubectl get secret api-credentials -o yaml
```{{execute}}

```bash
# stringData при apply превращается в data (base64)
kubectl get secret api-credentials   -o jsonpath='{.data.API_URL}' | base64 -d
echo ""
```{{execute}}
