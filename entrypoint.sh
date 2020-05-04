#!/bin/sh

set -e

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

Namespace=$(find / -name "namespace*")
Configmap=$(find / -name "configmap*")
Secret=$(find / -name secret.yaml)
Deployment=$(find / -name deployment.yaml)
Service=$(find / -name service.yaml)

for yaml in $Namespace
do
    kubectl apply -f $yaml
done

for yaml in $Configmap
do
    kubectl apply -f $yaml
done

for yaml in $Secret
do
    kubectl apply -f $yaml
done

for yaml in $Deployment
do
    kubectl apply -f $yaml
done

for yaml in $Service
do
    kubectl apply -f $yaml
done

rm /tmp/config
