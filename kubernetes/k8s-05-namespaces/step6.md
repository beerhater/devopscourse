# Шаг 6: NetworkPolicy — сетевая изоляция между namespace

По умолчанию любой под в любом namespace может обращаться к любому другому. `NetworkPolicy` это исправляет.

> NetworkPolicy требует CNI-плагин с поддержкой политик (Calico, Cilium, Weave). В этом кластере проверим наличие.

```bash
kubectl get pods -n kube-system | grep -iE 'calico|cilium|weave|flannel'
```{{execute}}

## Политика: запретить весь входящий трафик

```bash
cat > deny-all.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
  namespace: production
spec:
  podSelector: {}       # Применяется ко ВСЕМ подам в namespace
  policyTypes:
  - Ingress             # Блокируем весь входящий трафик
  # Нет секции ingress — значит ничего не разрешено
EOF
kubectl apply -f deny-all.yaml
```{{execute}}

## Политика: разрешить только из своего namespace

```bash
cat > allow-same-ns.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-same-namespace
  namespace: development
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector: {}   # Любой под из ТОГО ЖЕ namespace
EOF
kubectl apply -f allow-same-ns.yaml
```{{execute}}

## Политика: разрешить из конкретного namespace

```bash
cat > allow-from-staging.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-staging
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: my-app
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          env: staging      # Только из namespace с label env=staging
    - podSelector:
        matchLabels:
          role: api-gateway  # И только от подов с этим label
    ports:
    - protocol: TCP
      port: 80
EOF

# Вешаем label на namespace staging
kubectl label namespace staging env=staging
kubectl apply -f allow-from-staging.yaml
kubectl get networkpolicies -n production
kubectl get networkpolicies -n development
```{{execute}}

```bash
kubectl describe networkpolicy allow-from-staging -n production
```{{execute}}
