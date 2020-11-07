
export OPERATOR_IMAGE=ironrainindustries/ironforge-operator:v0.1
export RBAC_IMG=gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0
export NAMESPACE=ironforge-operator

sed -i "/        image:/c\        image: $RBAC_IMG" deploy/default/manager_auth_proxy_patch.yaml
sed -i "/      - image:/c\      - image: $OPERATOR_IMAGE" deploy/manager/manager.yaml
sed -i "/  name: system/c\  name: $NAMESPACE" deploy/manager/manager.yaml
sed -i "/namespace:/c\namespace: $NAMESPACE" deploy/default/kustomization.yaml
sed -i "/namePrefix:/c\#namePrefix:" deploy/default/kustomization.yaml

