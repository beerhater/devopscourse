# Шаг 4: NodePort — доступ снаружи кластера

`NodePort` открывает порт на **каждом узле** кластера. Трафик на `<NodeIP>:<NodePort>` попадает в Service и балансируется между подами.

Диапазон NodePort: `30000–32767`.

## Создаём NodePort Service

```bash
cat > nodeport.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: demo-nodeport
spec:
  type: NodePort
  selector:
    app: demo-app
  ports:
  - name: http
    port: 80             # ClusterIP порт (внутри кластера)
    targetPort: 80       # Порт пода
    nodePort: 30080      # Внешний порт на каждом узле (30000-32767)
    protocol: TCP
EOF
kubectl apply -f nodeport.yaml
kubectl get service demo-nodeport
```{{execute}}

```bash
# Видим все три колонки: PORT(S) = 80:30080/TCP
kubectl describe service demo-nodeport
```{{execute}}

## Обращаемся через NodePort

```bash
# Узнаём IP узлов
kubectl get nodes -o wide
```{{execute}}

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "Node IP: $NODE_IP"
curl -s http://$NODE_IP:30080/ | grep -o '<title>.*</title>'
```{{execute}}

```bash
# Работает с ЛЮБОГО узла кластера
NODE_IP2=$(kubectl get nodes -o jsonpath='{.items[1].status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null || echo "single-node")
echo "Second node: $NODE_IP2"
[ "$NODE_IP2" != "single-node" ] && curl -s http://$NODE_IP2:30080/ | grep -o '<title>.*</title>' || echo "One node in this cluster"
```{{execute}}

## Автоматический NodePort (без указания порта)

```bash
cat > nodeport-auto.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: demo-nodeport-auto
spec:
  type: NodePort
  selector:
    app: demo-app
  ports:
  - port: 80
    targetPort: 80
    # nodePort не указан — K8s назначит сам из диапазона 30000-32767
EOF
kubectl apply -f nodeport-auto.yaml
kubectl get service demo-nodeport-auto
```{{execute}}

```bash
AUTO_PORT=$(kubectl get service demo-nodeport-auto -o jsonpath='{.spec.ports[0].nodePort}')
echo "Назначенный NodePort: $AUTO_PORT"
curl -s http://$NODE_IP:$AUTO_PORT/ | grep -o '<title>.*</title>'
```{{execute}}
