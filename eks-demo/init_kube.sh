#!/bin/bash

mkdir .config
terraform output kubeconfig > .config/ekskubeconfig # save output in ~/.kube/config or use the following env prarm

export  KUBECONFIG=$KUBECONFIG:$(pwd)/.config/ekskubeconfig

terraform output config-map-aws-auth > .config/config-map-aws-auth.yaml # save output in config-map-aws-auth.yaml

kubectl apply -f .config/config-map-aws-auth.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml

kubectl apply -f eks-admin-service-account.yaml
kubectl apply -f eks-admin-cluster-role-binding.yaml

kubectl create -f gp2-storage-class.yaml

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

kubectl proxy &

echo 'Remember to setup your terminal env for kubectl: $ export  KUBECONFIG=$KUBECONFIG:$(pwd)/.config/ekskubeconfig'

open http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/