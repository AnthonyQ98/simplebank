#!/usr/bin/env bash

kubectl apply -f k8s-resources/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.0/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml

# other required steps: get the address from the ingress created when the above is applied & update Route 53 accordingly. As I destroy all AWS resources between each development session for cost saving purposes, these manual steps are partially required.