#!/bin/bash
export OPERATOR_IMAGE=ironrainindustries/ironforge-operator:v0.1
export RBAC_IMG=gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0
export NAMESPACE=ironforge-operator

export KEYCLOAK_URL=https://keycloak.keycloak.192.168.0.179.xip.io/auth
export KEYCLOAK_GROUP=code-users
export KEYCLOAK_SCOPE="openid email profile"
export KEYCLOAK_CLIENT_ID=oauth2
export KEYCLOAK_CLIENT_SECRET=ff0f6ddb-ce8a-4998-8113-9c13efa6b438
export AUTH_IMAGE_REGISTRY=quay.io
export AUTH_IMAGE_REPOSITORY=oauth2-proxy/oauth2-proxy
export AUTH_IMAGE_TAG=v6.1.1

sed -i "/        image:/c\        image: $RBAC_IMG" deploy/default/manager_auth_proxy_patch.yaml
sed -i "/      - image:/c\      - image: $OPERATOR_IMAGE" deploy/manager/manager.yaml
sed -i "/  name: system/c\  name: $NAMESPACE" deploy/manager/manager.yaml
sed -i "/namespace:/c\namespace: $NAMESPACE" deploy/default/kustomization.yaml
sed -i "/namePrefix:/c\#namePrefix:" deploy/default/kustomization.yaml
sed -i "s/controller-manager/ironforge-manager/g" deploy/default/manager_auth_proxy_patch.yaml
sed -i "s/controller-manager/ironforge-manager/g" deploy/manager/manager.yaml

sed -i "/        name: manager/i\        env:\n        - name: KEYCLOAK_URL\n          value: $KEYCLOAK_URL\n        - name: KEYCLOAK_SCOPE\n          value: $KEYCLOAK_SCOPE\n        - name: KEYCLOAK_GROUP\n          value: $KEYCLOAK_GROUP\n        - name: KEYCLOAK_CLIENT_ID\n          value: $KEYCLOAK_CLIENT_ID\n        - name: KEYCLOAK_CLIENT_SECRET\n          value: $KEYCLOAK_CLIENT_SECRET\n        - name: AUTH_IMAGE_REGISTRY\n          value: $AUTH_IMAGE_REGISTRY\n        - name: AUTH_IMAGE_REPOSITORY\n          value: $AUTH_IMAGE_REPOSITORY\n        - name: AUTH_IMAGE_TAG\n          value: $AUTH_IMAGE_TAG" deploy/manager/manager.yaml

kubectl apply -k ./deploy/default

