#!/bin/bash
rm -rf build
mkdir build
cd build 

operator-sdk init --plugins=helm --domain=io --group=ironforge --version=v1alpha1 --kind=IronForge --helm-chart=../../chart/

docker build . -t ironrainindustries/ironforge-operator:v0.1

docker push ironrainindustries/ironforge-operator:v0.1

cd ..

rm -rf deploy

mkdir deploy

mv --force build/config/samples/ironforge_v1alpha1_ironforge.yaml build/config/crd build/config/manager build/config/default build/config/rbac ./deploy 

rm -rf build



cat << EOF > deploy.sh 

export OPERATOR_IMAGE=ironrainindustries/ironforge-operator:v0.1
export RBAC_IMG=gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0
export NAMESPACE=ironforge-operator

sed -i "/        image:/c\        image: \$RBAC_IMG" deploy/default/manager_auth_proxy_patch.yaml
sed -i "/      - image:/c\      - image: \$OPERATOR_IMAGE" deploy/manager/manager.yaml
sed -i "/  name: system/c\  name: \$NAMESPACE" deploy/manager/manager.yaml
sed -i "/namespace:/c\namespace: \$NAMESPACE" deploy/default/kustomization.yaml
sed -i "/namePrefix:/c\#namePrefix:" deploy/default/kustomization.yaml

EOF
