# Шаг 4: Расширяем роль на чтение configmaps

Теперь аккуратно расширим роль, не давая лишнего.

```bash
cat > /root/rbac-demo-extended.yaml <<'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list"]
EOF

kubectl apply -f /root/rbac-demo-extended.yaml
kubectl auth can-i get configmaps --as=system:serviceaccount:default:viewer > /root/rbac_configmaps_after.txt
cat /root/rbac_configmaps_after.txt
```{{execute}}
