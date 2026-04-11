# Шаг 1: Настраиваем RBAC для чтения pod

Создайте service account, role и rolebinding, а затем проверьте права.

```bash
cat > /root/rbac-demo.yaml <<'EOF'
apiVersion: v1
kind: ServiceAccount
metadata:
  name: viewer
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
subjects:
  - kind: ServiceAccount
    name: viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-reader
EOF

kubectl apply -f /root/rbac-demo.yaml
kubectl auth can-i get pods --as=system:serviceaccount:default:viewer > /root/rbac_can_get.txt
kubectl auth can-i delete pods --as=system:serviceaccount:default:viewer > /root/rbac_can_delete.txt
kubectl get rolebinding pod-reader-binding > /root/rbac_binding.txt

cat /root/rbac_can_get.txt
cat /root/rbac_can_delete.txt
```{{execute}}

Это и есть суть production RBAC:
дать ровно столько прав, сколько нужно, и не больше.
