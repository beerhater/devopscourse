# Шаг 5: LoadBalancer — продакшн в облаке

`LoadBalancer` запрашивает у облачного провайдера (AWS, GCP, Azure) внешний балансировщик нагрузки. Он автоматически получает публичный IP.

## Как устроен LoadBalancer

```
Internet
    │
    ▼
Cloud LB (публичный IP: 34.x.x.x)
    │
    ├──► Node1:30080
    ├──► Node2:30080
    └──► Node3:30080
              │
              ▼
         ClusterIP → Pods
```

`LoadBalancer` — это расширение `NodePort`: он создаёт `NodePort`, а потом просит облако направить трафик на узлы.

## Манифест LoadBalancer

```bash
cat > loadbalancer.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: demo-lb
  annotations:
    # AWS: выбор схемы балансировщика
    # service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
    # GCP: статический IP
    # cloud.google.com/load-balancer-type: External
spec:
  type: LoadBalancer
  selector:
    app: demo-app
  ports:
  - name: http
    port: 80
    targetPort: 80
    protocol: TCP
EOF
kubectl apply -f loadbalancer.yaml
kubectl get service demo-lb
```{{execute}}

```bash
# В Killercoda нет облака — EXTERNAL-IP будет <pending>
# В реальном облаке здесь появится публичный IP
kubectl describe service demo-lb
```{{execute}}

```bash
# Наблюдаем: LoadBalancer создаёт NodePort под капотом
kubectl get service demo-lb -o jsonpath='{.spec.ports[0].nodePort}'
echo ""
```{{execute}}

## Сравнение типов Service

| | ClusterIP | NodePort | LoadBalancer |
|-|-----------|----------|--------------|
| Доступен снаружи | ❌ | ✅ (только NodePort) | ✅ (публичный IP) |
| Нужен облачный провайдер | ❌ | ❌ | ✅ |
| Балансировка | Внутренняя | NodeIP:Port | Облачная |
| Продакшн | ✅ (между сервисами) | ⚠️ (dev/staging) | ✅ (публичный трафик) |
| Цена | Бесплатно | Бесплатно | Облако тарифицирует |

## MetalLB — LoadBalancer без облака

В bare-metal кластерах используют MetalLB — он выдаёт IP из локального пула:

```bash
# Смотрим — MetalLB не установлен в этом кластере
kubectl get pods -n metallb-system 2>/dev/null || echo "MetalLB не установлен"
```{{execute}}

```bash
kubectl delete service demo-lb
```{{execute}}
